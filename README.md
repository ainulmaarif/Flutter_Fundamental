# Laporan Praktikum Flutter - Navigasi dan Pemrosesan Rute

**Identitas Mahasiswa**
- **Nama:** Ainul Ma'arif Al Mashuri
- **NIM:** 23.52.0010
- **Mata Kuliah:** [Isi dengan nama mata kuliah, misal: Pemrograman Perangkat Bergerak]

## Deskripsi Praktikum
Praktikum ini berfokus pada implementasi navigasi antar-layar dan manajemen alur data pada aplikasi Flutter. Beberapa poin utama yang telah diselesaikan dalam tugas ini meliputi:
1. **Tata Letak Grid Responsif:** Menerapkan `GridView.builder` dengan 2 kolom dan rasio aspek yang disesuaikan untuk menghindari *RenderFlex overflow*.
2. **Named Routes & Passing Data:** Menerapkan rute bernama untuk berpindah halaman dan mengirimkan objek data `Item` menggunakan parameter `arguments`.
3. **Ekstraksi Data:** Mengambil data argumen secara aman di layar tujuan menggunakan `ModalRoute.of(context)!.settings.arguments as Item`.
4. **Hero Animation:** Menambahkan transisi visual yang halus antar-layar menggunakan widget `Hero` dengan tag unik.
5. **Modular Widget:** Memisahkan komponen UI menjadi widget mandiri yang *reusable* seperti `CarCard` dan `FooterWidget`.
6. **GoRouter (Opsional/Tambahan):** Menguji coba perutean berbasis URL menggunakan *package* `go_router`.

## Demo Aplikasi
Berikut adalah hasil akhir dari aplikasi yang telah berjalan dengan lancar beserta animasi transisinya:

![Demo Praktikum Aplikasi](assets/per6-prak1.gif)

## Catatan Perbaikan Kode (Error Handling)
Selama pengerjaan, terdapat penyesuaian kode agar aplikasi berjalan optimal:
- **RenderFlex Overflow:** Menyesuaikan nilai `childAspectRatio` pada `GridView` agar elemen di dalam kartu (gambar dan teks) tidak keluar dari batas layar (overflow) pada ukuran layar yang berbeda.
- **Null Safety pada Arguments:** Memastikan proses *type casting* pada `ModalRoute` dilakukan dengan aman agar tidak terjadi *null check operator error* saat data objek dikirimkan.