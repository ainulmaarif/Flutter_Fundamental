import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/main.dart';

void main() {
  testWidgets('Rental Mobil Malang App loads and navigates correctly',
      (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi keberadaan judul AppBar dan Footer identitas mahasiswa
    expect(find.text('Rental Mobil Malang'), findsWidgets);
    expect(
      find.text('Ainul - 23520010 • Rental Mobil Malang'),
      findsOneWidget,
    );

    // Verifikasi data mobil pertama tampil di katalog
    expect(find.text('Toyota Avanza 1.5 G'), findsOneWidget);

    // Klik kartu mobil untuk navigasi ke ItemPage dengan arguments
    await tester.tap(find.text('Toyota Avanza 1.5 G'));
    await tester.pumpAndSettle();

    // Verifikasi halaman detail terbuka dengan rincian dan tombol 'Sewa Sekarang'
    expect(find.text('Toyota Avanza 1.5 G'), findsWidgets);
    expect(find.text('Sewa Sekarang'), findsOneWidget);
    expect(find.text('Spesifikasi Kendaraan'), findsOneWidget);
    expect(
      find.text('Ainul - 23520010 • Rental Mobil Malang'),
      findsOneWidget,
    );

    // Verifikasi tombol kembali ke halaman utama
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Katalog Armada Pilihan'), findsOneWidget);
  });
}
