import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `ProductsNotifier` mengelola state katalog produk secara asinkron menggunakan `AsyncNotifier`.
/// Mewarisi `AsyncNotifier<List<String>>` persis sesuai panduan Modul 06 Halaman 29–31.
/// Mengatur transisi tiga state utama: Loading, Error, dan Data (Success).
class ProductsNotifier extends AsyncNotifier<List<String>> {
  /// Variabel internal statis untuk simulasi galat agar nilainya persisten
  /// saat provider di-invalidate (re-instantiated oleh Riverpod).
  static bool _isErrorSimulated = false;

  /// Getter boolean internal untuk membaca status simulasi galat
  bool get isErrorSimulated => _isErrorSimulated;

  /// Metode interaktif untuk mengaktifkan atau menonaktifkan simulasi galat
  /// tanpa perlu mengubah kode sumber secara manual.
  void toggleErrorSimulation(bool value) {
    _isErrorSimulated = value;
  }

  /// Metode build() dipanggil saat provider pertama kali dibaca atau di-invalidate.
  @override
  Future<List<String>> build() async {
    // State 1: Simulasi jeda waktu jaringan selama 2 detik (Loading State)
    await Future.delayed(const Duration(seconds: 2));

    // State 2: Simulasi galat ketika isErrorSimulated bernilai true (Error State)
    if (_isErrorSimulated) {
      throw Exception('Gagal terhubung ke server');
    }

    // State 3: Mengembalikan 3 produk awal saat kondisi normal (Success State)
    return ['Keyboard', 'Mouse', 'Monitor'];
  }

  /// Fungsi internal pengambilan data 4 produk (termasuk item ke-4: Headset).
  Future<List<String>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_isErrorSimulated) {
      throw Exception('Gagal terhubung ke server');
    }
    return ['Keyboard', 'Mouse', 'Monitor', 'Headset'];
  }

  /// Metode refresh untuk memperbarui daftar produk menggunakan AsyncValue.guard()
  /// persis sesuai panduan Halaman 29 Modul 06.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }
}

/// Provider global dengan tipe eksplisit sesuai instruksi Modul 06
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<String>>(ProductsNotifier.new);
