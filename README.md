# 🚗 Platform Rental Mobil Malang (Flutter)

Aplikasi rental mobil (sewa mobil) berbasis Flutter dengan antarmuka modern Material 3, katalog grid dua kolom, navigasi halaman dengan transfer data dinamis, transisi halus `Hero`, serta reusable widget modular.

---

## 👤 Identitas Mahasiswa
* **Nama** : Ainul  
* **NIM** : 23520010  
* **Program Studi** : S1 Teknik Informatika  
* **Mata Kuliah** : Pemrograman Bergerak (Mobile Programming)  
* **Topik** : Navigasi & Rute, Transfer Data, GridView, Hero Animation, Reusable Widgets  

---

## 📁 Struktur Direktori Proyek

```text
lib/
├── main.dart                  # Entry point aplikasi, route mapping, tema Material 3
├── models/
│   └── item.dart              # Model data Item (nama, harga, foto, rating, stok, dll)
├── pages/
│   ├── home_page.dart         # Halaman utama katalog mobil (GridView.builder 2 kolom)
│   └── item_page.dart         # Halaman rincian mobil (ModalRoute arguments, Hero animation)
└── widgets/
    ├── car_card.dart          # Reusable card mobil untuk grid katalog
    └── footer_widget.dart     # Reusable footer identitas ("Ainul - 23520010 • Rental Mobil Malang")
test/
└── widget_test.dart           # Automated test navigasi dan verifikasi UI
```

---

## 🌟 Fitur Utama & Penjelasan Implementasi

### 1. Model Data (`lib/models/item.dart`)
Kelas `Item` bertindak sebagai model entitas kendaraan dengan atribut lengkap:
* `name` (`String`): Nama armada mobil (contoh: Toyota Avanza 1.5 G, Mitsubishi Xpander Ultimate, Toyota Innova Zenix Hybrid, Honda Brio RS, Toyota Fortuner VRZ 4x4, Toyota HiAce Commuter).
* `price` (`int`): Tarif sewa harian (per 24 jam) dalam satuan Rupiah.
* `photo` (`String`): Tautan gambar asli akurat dari Wikimedia Commons.
* `stock` (`int`): Jumlah unit mobil yang tersedia di pool Malang.
* `rating` (`double`): Penilaian kepuasan pelanggan (skala 1.0 – 5.0).
* `transmission` (`String`): Tipe transmisi kendaraan (`Matic` atau `Manual`).
* `capacity` (`int`): Kapasitas penumpang (jumlah kursi).
* `fuel` (`String`): Jenis bahan bakar (`Bensin` / `Hybrid`).
* `description` (`String`): Deskripsi detail keunggulan dan peruntukan armada.

### 2. Reusable Widgets (`lib/widgets/`)
Untuk mematuhi prinsip *Don't Repeat Yourself (DRY)* dan *clean architecture*, komponen UI modular dipisahkan ke dalam folder `widgets/`:
* **`FooterWidget` (`footer_widget.dart`)**:
  * Menampilkan identitas resmi:  
    `"Ainul - 23520010 • Rental Mobil Malang"`
  * Menggunakan `SafeArea` dengan styling warna latar belakang adaptif terhadap palet tema Material 3 (`surfaceContainerHighest`) dan ikon kendaraan untuk tampilan elegan.
  * Disematkan secara konsisten di bagian bawah layar baik pada `HomePage` maupun `ItemPage`.
* **`CarCard` (`car_card.dart`)**:
  * Kartu produk responsif untuk katalog grid.
  * Membungkus foto mobil dengan `Hero(tag: item.name)`.
  * Menampilkan badge transmisi di atas gambar, nama mobil, harga sewa berformat mata uang Rupiah (`Rp xxx.xxx/hari`), rating bintang dengan ikon amber, kapasitas kursi, serta indikator ketersediaan stok warna hijau/merah.
  * Dilengkapi penanganan fallback gambar (`loadingBuilder` & `errorBuilder`) agar tampilan tetap rapi meskipun koneksi internet terganggu.

### 3. Katalog Responsif dengan `GridView.builder` (`lib/pages/home_page.dart`)
* Menggunakan `GridView.builder` dengan `crossAxisCount: 2` (2 kolom) untuk menyusun kartu armada mobil secara efisien dan hemat memori (lazy-loading).
* Parameter `childAspectRatio: 0.70` memastikan proporsi kartu seimbang dan tidak terjadi *RenderFlex overflow* pada berbagai resolusi layar.
* Katalog menyediakan 6 unit mobil populer di Malang Raya dengan foto asli akurat (Toyota Avanza 1.5 G, Mitsubishi Xpander Ultimate, Toyota Innova Zenix Hybrid, Honda Brio RS, Toyota Fortuner VRZ 4x4, Toyota HiAce Commuter).

### 4. Navigasi & Pengiriman Data (`Navigator.pushNamed` arguments)
Ketika pengguna memilih salah satu kartu mobil pada `HomePage`, aplikasi memicu navigasi rute bernama (*named route*) dengan menyisipkan objek `item` utuh sebagai parameter `arguments`:

```dart
Navigator.pushNamed(
  context,
  '/item',
  arguments: car,
);
```

### 5. Ekstraksi Data dengan `ModalRoute` (`lib/pages/item_page.dart`)
Pada `ItemPage`, objek mobil diekstrak langsung dari konteks navigasi menggunakan:

```dart
final item = ModalRoute.of(context)!.settings.arguments as Item;
```

Data tersebut kemudian digunakan untuk merender:
* Gambar mobil resolusi penuh dengan animasi `Hero`.
* Header nama mobil dan status ketersediaan unit.
* Tarif sewa per 24 jam dengan kontainer beraksen warna utama.
* Rating bintang dan ulasan pelanggan.
* Grid spesifikasi 4 parameter: Kursi/Kapasitas, Transmisi, Bahan Bakar, dan Stok Unit.
* Rincian fasilitas rental (asuransi all-risk, kebersihan disinfeksi, darurat 24 jam, antar-jemput Malang).
* Tombol aksi **'Sewa Sekarang'** interaktif yang memunculkan dialog konfirmasi dan snackbar pemesanan.
* Komponen `FooterWidget` di bagian paling bawah halaman.

### 6. Animasi Halus dengan Widget `Hero`
Transisi visual antar halaman dibuat mulus memanfaatkan `Hero animation`:
* **Pada `CarCard`**: Widget gambar dibungkus dengan `Hero(tag: item.name, child: ...)`.
* **Pada `ItemPage`**: Widget gambar detail dibungkus dengan pasangan `Hero(tag: item.name, child: ...)`.
* **Mekanisme**: Flutter otomatis menghitung posisi (*rect*) gambar awal di grid, menganimasikan perbesaran dan pergeseran ke posisi header di halaman detail selama transisi rute berlangsung tanpa *jank*.

### 7. Konfigurasi Rute & Tema (`lib/main.dart`)
Aplikasi dikonfigurasi menggunakan rute bernama Navigator 1.0:
```dart
MaterialApp(
  title: 'Rental Mobil Malang - Ainul (23520010)',
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) => const HomePage(),
    '/item': (context) => const ItemPage(),
  },
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
  ),
);
```

---

## ⚖️ Analisis Perbandingan: Navigator 1.0 vs GoRouter

Dalam ekosistem Flutter, manajemen navigasi dan rute telah berevolusi dari model tumpukan imperatif dasar ke perutean deklaratif modern. Berikut perbandingan mendalam antara **Navigator 1.0** dan **GoRouter (Navigator 2.0 wrapper)**:

| Aspek Evaluasi | Navigator 1.0 (`Navigator.push` / `pushNamed`) | GoRouter (Declarative Routing / Router API) |
| :--- | :--- | :--- |
| **Paradigma Arsitektur** | **Imperatif (Stack-based)**: Pengembang memanipulasi *navigation stack* secara manual dengan perintah *push* dan *pop*. | **Deklaratif (URL & State-driven)**: Halaman aplikasi merupakan proyeksi dari *state* URL saat ini. Tumpukan halaman disinkronkan secara otomatis. |
| **Penerusan Data (Parameter Passing)** | Menggunakan properti `arguments: Object?` pada `pushNamed`. Objek utuh dalam memori dapat langsung dikirim tanpa serialisasi. | Menggunakan kombinasi `pathParameters` (misal `/item/:id`), `queryParameters`, dan `extra` (untuk objek in-memory). |
| **Dukungan Web & Deep Linking** | **Sangat Terbatas & Rentan Masalah**: URL pada browser tidak selalu sinkron dengan state tumpukan. Jika pengguna me-refresh halaman web, rute bisa hilang atau `arguments` bernilai `null` karena tidak tersimpan pada URL. | **Native & Luar Biasa (First-Class Support)**: URL web selalu sinkron dua arah. Mendukung *direct URL entry*, *browser history* (tombol Back/Forward browser), dan *deep linking* mobile (Android App Links / iOS Universal Links). |
| **Autentikasi & Route Guards** | Sulit diatur secara terpusat. Pengecekan status login harus diselipkan di setiap `onTap` sebelum `pushNamed`, atau membuat logika kompleks di `onGenerateRoute`. | **Sangat Bersih & Terpusat via `redirect`**: Mendukung fungsi `redirect: (context, state)` yang otomatis mengarahkan ke halaman `/login` jika sesi pengguna berakhir, terlepas dari rute mana yang diakses. |
| **Nested Navigation & Bottom Navigation Bar** | Memerlukan widget `Navigator` bersarang (*nested Navigator*) manual dengan `GlobalKey` berbeda, rentan kebocoran memori atau kebingungan penanganan tombol back Android. | **Sangat Mudah via `ShellRoute` / `StatefulShellRoute`**: Mempertahankan state tab / bottom navigation bar secara independen (*state preservation*) dengan sintaks ringkas. |
| **Tingkat Kompleksitas Setup** | **Sangat Sederhana**: Cukup mendefinisikan map `routes: { '/': ..., '/item': ... }` langsung di `MaterialApp`. Cocok untuk pemula dan aplikasi skala kecil-menengah. | **Menengah ke Atas**: Memerlukan import package `go_router`, inisialisasi konfigurasi `GoRouter`, penanganan error rute, serta pemahaman paradigma deklaratif. |

### Rekomendasi Kapan Harus Menggunakan Masing-Masing:
1. **Gunakan Navigator 1.0 jika:**
   * Aplikasi berfokus murni pada platform mobile (Android/iOS) dengan alur tumpukan halaman linier standar.
   * Proyek tugas akademik, prototyping cepat, atau aplikasi skala kecil yang mengutamakan kesederhanaan kode tanpa dependensi pihak ketiga tambahan.
   * Tidak memerlukan deep linking kompleks dari notifikasi eksternal atau URL web.
2. **Gunakan GoRouter jika:**
   * Aplikasi dibangun untuk multiplatform (terutama **Flutter Web** dan Mobile) di mana URL browser dan tombol Back/Forward wajib berfungsi normal.
   * Aplikasi memiliki alur autentikasi dinamis (guard rute berbasis status login).
   * Memerlukan *nested routing* yang kompleks, seperti dashboard admin dengan sidebar persisten atau mobile app dengan persistent Bottom Navigation Bar.

---

## 🧪 Pengujian & Verifikasi Kualitas

Proyek ini telah dilengkapi automated widget test pada [test/widget_test.dart](test/widget_test.dart) yang memvalidasi:
1. Pemanggilan dan perenderan halaman utama katalog (`HomePage`).
2. Tampilan judul "Rental Mobil Malang" dan identitas mahasiswa pada `FooterWidget`.
3. Deteksi kartu mobil (`Toyota All New Avanza`).
4. Eksekusi navigasi via `Navigator.pushNamed(context, '/item', arguments: car)`.
5. Verifikasi perenderan halaman detail (`ItemPage`), spesifikasi kendaraan, tombol 'Sewa Sekarang', dan `FooterWidget`.
6. Pengujian kembali ke halaman utama (*pop route*).

---

## 🚀 Panduan Menjalankan Proyek

1. **Pastikan Flutter SDK terpasang:**
   ```bash
   flutter --version
   ```
2. **Unduh dependensi proyek:**
   ```bash
   flutter pub get
   ```
3. **Jalankan analisis kode:**
   ```bash
   flutter analyze
   ```
4. **Jalankan automated test:**
   ```bash
   flutter test
   ```
5. **Jalankan aplikasi di perangkat emulator/Chrome:**
   ```bash
   flutter run -d chrome
   # atau
   flutter run
   ```
