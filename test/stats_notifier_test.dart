import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_world/pages/stats_page.dart';

/// Generator bilangan acak tiruan (Fake Random) untuk pengujian deterministik.
/// Memungkinkan penguji mengontrol secara pasti apakah logika < 0.3 terpenuhi atau tidak.
class FakeRandom implements Random {
  double _value;

  FakeRandom(this._value);

  void setValue(double val) {
    _value = val;
  }

  @override
  double nextDouble() => _value;

  @override
  int nextInt(int max) => 0;

  @override
  bool nextBool() => false;
}

void main() {
  group('StatsNotifier Unit Tests (ProviderContainer)', () {
    // =========================================================================
    // UJI SKENARIO 1: SUKSES (Data mengembalikan 3 item statistik ringkas)
    // =========================================================================
    test(
        'Skenario Sukses: StatsNotifier berhasil mengembalikan 3 item statistik ringkas',
        () async {
      // 1. Inisialisasi FakeRandom dengan nilai 0.7 (>= 0.3 sehingga tidak memicu error)
      final deterministicRandom = FakeRandom(0.7);

      // 2. Buat ProviderContainer murni dengan meng-override statsProvider
      //    networkDelay disetel ke Duration.zero agar pengujian selesai secara instan
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(
              random: deterministicRandom,
              networkDelay: Duration.zero,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      // 3. Baca initial state saat pertama kali diakses (harus berupa AsyncLoading)
      expect(
        container.read(statsProvider),
        isA<AsyncLoading<List<String>>>(),
        reason: 'State awal harus berupa AsyncLoading saat sedang proses fetch',
      );

      // 4. Tunggu penyelesaian future data statistik
      final statsList = await container.read(statsProvider.future);

      // 5. Verifikasi kepatuhan data terhadap spesifikasi modul praktikum
      expect(statsList.length, 3, reason: 'Harus terdapat tepat 3 item statistik');
      expect(
        statsList[0],
        'Total Tugas Selesai: 18 Tugas',
        reason: 'Item 1 harus mencantumkan total tugas selesai',
      );
      expect(
        statsList[1],
        'Tingkat Produktivitas: 92%',
        reason: 'Item 2 harus mencantumkan tingkat produktivitas',
      );
      expect(
        statsList[2],
        'Waktu Fokus Mingguan: 24 Jam',
        reason: 'Item 3 harus mencantumkan waktu fokus mingguan',
      );

      // 6. Pastikan state akhir di dalam container adalah AsyncData
      final finalState = container.read(statsProvider);
      expect(finalState, isA<AsyncData<List<String>>>());
      expect(finalState.value, equals(statsList));
    });

    // =========================================================================
    // UJI SKENARIO 2: GALAT (Provider menangkap Exception saat simulasi gagal)
    // =========================================================================
    test(
        'Skenario Galat: Provider menangkap Exception saat probabilitas 30% terpenuhi',
        () async {
      // 1. Inisialisasi FakeRandom dengan nilai 0.2 (< 0.3 sehingga memicu pelemparan galat)
      final failureRandom = FakeRandom(0.2);

      // 2. Buat ProviderContainer dengan retry handler null untuk mencegah uncaught test error
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(
              random: failureRandom,
              networkDelay: Duration.zero,
            ),
          ),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);

      // Pasang listener aktif agar container memantau transisi lifecycle provider
      final subscription = container.listen(statsProvider, (_, _) {});
      addTearDown(subscription.close);

      // 3. Pastikan future melempar Exception dengan pesan spesifik
      await expectLater(
        container.read(statsProvider.future),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Koneksi terputus (Simulasi gagal 30%)'),
          ),
        ),
      );

      // 4. Periksa apakah state provider bertransisi ke AsyncError
      final errorState = container.read(statsProvider);
      expect(
        errorState,
        isA<AsyncError<List<String>>>(),
        reason: 'State harus berupa AsyncError ketika fetch gagal',
      );

      // 5. Pastikan detail error di dalam AsyncError bertipe Exception
      expect(
        (errorState as AsyncError).error,
        isA<Exception>(),
      );
    });

    // =========================================================================
    // UJI SKENARIO 3: PEMULIHAN RETRY (Transisi dari Error ke Success)
    // =========================================================================
    test(
        'Skenario Retry: Memanggil retry() mengubah AsyncError menjadi AsyncData ketika koneksi pulih',
        () async {
      // 1. Mulai dengan kondisi gagal (nilai random 0.15 < 0.3)
      final dynamicRandom = FakeRandom(0.15);

      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(
              random: dynamicRandom,
              networkDelay: Duration.zero,
            ),
          ),
        ],
        retry: (_, _) => null,
      );
      addTearDown(container.dispose);

      final subscription = container.listen(statsProvider, (_, _) {});
      addTearDown(subscription.close);

      // 2. Tunggu hingga build awal selesai dan memicu error
      try {
        await container.read(statsProvider.future);
      } catch (_) {
        // Exception diharapkan tertangkap di sini
      }

      // Pastikan saat ini berada pada AsyncError
      expect(container.read(statsProvider), isA<AsyncError<List<String>>>());

      // 3. Pulihkan kondisi koneksi (ubah nilai random ke 0.85 >= 0.3)
      dynamicRandom.setValue(0.85);

      // 4. Eksekusi fungsi retry() pada notifier
      await container.read(statsProvider.notifier).retry();

      // 5. Pastikan state pulih menjadi AsyncData dan berisi 3 item statistik
      final recoveredState = container.read(statsProvider);
      expect(
        recoveredState,
        isA<AsyncData<List<String>>>(),
        reason: 'Setelah retry berhasil, state harus beralih ke AsyncData',
      );
      expect(recoveredState.value?.length, 3);
      expect(recoveredState.value?[0], 'Total Tugas Selesai: 18 Tugas');
    });
  });
}
