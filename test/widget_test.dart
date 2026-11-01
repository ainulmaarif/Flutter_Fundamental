import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_world/main.dart';

void main() {
  testWidgets('ProductPage menampilkan state loading dan berhasil menampilkan produk',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verifikasi judul AppBar identitas mahasiswa
    expect(find.text('Katalog Produk - Ainul (23520010)'), findsOneWidget);

    // Verifikasi kondisi Loading awal (2 detik)
    expect(find.text('Memuat data... (2 detik)'), findsOneWidget);

    // Tunggu simulasi loading selama 2 detik selesai
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verifikasi ketiga produk tampil di layar (Success state awal)
    expect(find.text('Keyboard'), findsOneWidget);
    expect(find.text('Mouse'), findsOneWidget);
    expect(find.text('Monitor'), findsOneWidget);

    // Tap tombol refresh untuk memuat 4 item (termasuk Headset)
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verifikasi item ke-4 (Headset) muncul
    expect(find.text('Headset'), findsOneWidget);

    // Tap item untuk memverifikasi fungsionalitas interaksi
    await tester.tap(find.text('Headset'));
    await tester.pump();
    expect(find.text('Item Headset dipilih dan berfungsi dengan baik'), findsOneWidget);
  });
}
