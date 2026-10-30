# Tugas Praktikum Flutter - Pertemuan 4: AI Prompt Challenge

**Nama:** Ainul  
**NIM:** 23520010  
**Program Studi:** S1 Teknik Informatika  
**Proyek:** Academic Overview Dashboard (`hello_world`)  
**Branch Git:** `pertemuan4`  

---

## Daftar Isi
1. [Ringkasan Challenge](#ringkasan-challenge)
2. [Challenge 1: Prompt Desain & Analisis Tradeoff](#challenge-1-prompt-desain--analisis-tradeoff)
3. [Challenge 2: Prompt Penguatan Konsep (Expanded vs Overflow di Row)](#challenge-2-prompt-penguatan-konsep-expanded-vs-overflow-di-row)
4. [Challenge 3: Verification Prompt (Self-Audit AI)](#challenge-3-verification-prompt-self-audit-ai)
5. [Keputusan Arsitektur yang Dipilih & Rationale Teknis](#keputusan-arsitektur-yang-dipilih--rationale-teknis)
6. [Bukti Verifikasi Teknis (Automated Testing & QA)](#bukti-verifikasi-teknis-automated-testing--qa)
7. [Panduan Menjalankan Proyek](#panduan-menjalankan-proyek)

---

## 1. Ringkasan Challenge
Pada tugas minggu ini, setelah implementasi mandiri dashboard akademik selesai, dilakukan **AI Prompt Challenge** untuk membandingkan dua alternatif tata letak, mendalami mekanisme render constraints Flutter, melakukan audit mandiri (self-audit) terhadap aksesibilitas dan responsivitas, serta mendokumentasikan keputusan teknis sebagai persiapan *code review*.

---

## 2. Challenge 1: Prompt Desain & Analisis Tradeoff

### Prompt yang Diajukan:
> *"Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan tradeoff responsif dan aksesibilitasnya."*

### Output Analisis Komparatif:

| Kriteria Evaluasi | Pendekatan A: `GridView` (`GridView.count` / `GridView.builder`) | Pendekatan B: `LayoutBuilder + Column` (Responsive Flex / Row) |
| :--- | :--- | :--- |
| **Mekanisme Tata Letak** | Menata kartu dalam petak kisi 2 dimensi (baris $\times$ kolom) yang dikunci oleh `crossAxisCount` dan `childAspectRatio`. | Mendeteksi lebar batas kontainer (`BoxConstraints.maxWidth`) secara dinamis, lalu menyusun kartu vertikal (`Column`) atau berpasangan horizontal (`Row`). |
| **Adaptabilitas Responsif** | **Kaku:** Membutuhkan penyesuaian `childAspectRatio` manual untuk berbagai rasio layar. Jika layar sangat sempit (<360px), rasio tetap membuat kartu terlalu pendek atau terlalu lebar. | **Sangat Adaptif:** Tinggi kartu bersifat *content-driven* (intrinsik). Kartu meregang secara alami mengikuti volume teks tanpa distorsi rasio. |
| **Dampak Font Scaling (Aksesibilitas)** | **Rentan Overflow:** Jika pengguna mengaktifkan fitur aksesibilitas *Large Font* / *Dynamic Type* (Text Scale Factor 1.5x–2.0x), teks melipat tetapi tinggi kartu dibatasi oleh `childAspectRatio`, menyebabkan **RenderFlex Overflow**. | **Sangat Ramah Aksesibilitas:** Karena tidak dikunci aspek rasio, tinggi kartu otomatis memanjang ke bawah saat font membesar tanpa pernah memicu overflow. |
| **Integrasi dalam ScrollView** | Jika ditaruh di dalam `ListView`, memerlukan `shrinkWrap: true` dan `physics: NeverScrollableScrollPhysics()` yang mematikan virtualisasi dan memicu *redundant layout pass*. | Mengalir alami di dalam `ListView` atau `SingleChildScrollView` tanpa anti-pattern `shrinkWrap`. |
| **Urutan Pembacaan Screen Reader** | Membaca grid baris-demi-baris secara kaku. Jika informasi kartu heterogen, alur navigasi TalkBack / VoiceOver bisa kurang alami. | Alur pembacaan linier dan terstruktur dari atas ke bawah sesuai hierarki logis kartu informasi. |

---

## 3. Challenge 2: Prompt Penguatan Konsep (Expanded vs Overflow di Row)

### Prompt yang Diajukan:
> *"Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya."*

### Penjelasan Konseptual:
Di Flutter, widget `Expanded` berfungsi memberikan *tight constraint* pada sumbu utama (`mainAxis`) `Row` agar anak mengisi sisa ruang yang tersedia berdasarkan nilai `flex`. Namun, `Expanded` justru memicu **assertion failure** atau **RenderFlex Overflow** pada dua kondisi utama:

1. **Unbounded Main Axis (Lebar Horizontal Tak Terhingga):**
   Ketika `Row` diletakkan di dalam kontainer yang tidak membatasi lebar (misalnya `SingleChildScrollView(scrollDirection: Axis.horizontal)` atau `ListView(scrollDirection: Axis.horizontal)`). `Row` menerima `maxWidth: double.infinity`. Ketika `Expanded` mencoba membagi ruang `infinity`, perhitungan gagal dan Flutter melempar exception:
   `"BoxConstraints forces an infinite width."`
2. **Vertical Overflow Akibat Fixed Cross-Axis:**
   Ketika `Row` berada di dalam kontainer dengan tinggi kaku (misal `SizedBox(height: 50)`). `Expanded` memang mencegah overflow horizontal, namun ketika teks panjang di dalam `Expanded` membungkus ke 3–4 baris, tinggi total melebihi 50px sehingga memicu:
   `"A RenderFlex overflowed by xx pixels on the bottom."`

### Contoh Kode yang Gagal (Failure Case):

```dart
// KASUS GAGAL: Expanded di dalam Horizontal ScrollView
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      const Text('Label:'),
      // ERROR FATAL: Expanded mencoba mengambil ruang dari lebar tak berhingga!
      Expanded(
        child: Container(
          color: Colors.blue,
          child: const Text('Teks ini menyebabkan runtime crash'),
        ),
      ),
    ],
  ),
)
```

### Kode Perbaikan (Fixed Code):

```dart
// PERBAIKAN 1: Gunakan ConstrainedBox atau batas lebar eksplisit
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      const Text('Label:'),
      const SizedBox(width: 8),
      ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 150, maxWidth: 300),
        child: Container(
          color: Colors.blue,
          child: const Text(
            'Teks aman karena memiliki batasan lebar terdefinisi',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ],
  ),
)

// PERBAIKAN 2: Jika di dalam Row normal pada Card (seperti InfoCard kami)
// Biarkan tinggi intrinsik, bungkus teks dengan Expanded agar aman dari overflow horizontal:
Row(
  children: [
    Expanded(
      child: Text(
        'Judul Kartu Yang Sangat Panjang Sekali',
        style: theme.textTheme.titleMedium,
        softWrap: true, // Teks melipat ke bawah secara dinamis tanpa batasan tinggi kaku
      ),
    ),
    const SizedBox(width: 8),
    Text('3.88', style: theme.textTheme.headlineSmall),
  ],
)
```

---

## 4. Challenge 3: Verification Prompt (Self-Audit AI)

### Prompt yang Diajukan:
> *"Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"*

### Hasil Audit Mandiri:

1. **Audit Responsivitas di Bawah 600px (< 600px):**
   - **Status: Terverifikasi Aman.**
   - Breakpoint aplikasi diatur pada `kWideBreakpoint = 700`. Pada layar ponsel (<600px, diuji pada 360px $\times$ 800px dan layar ultra-sempit 320px $\times$ 568px), layout beralih ke 1 kolom vertikal (`columns = 1`).
   - Elemen header profil menggunakan `Row` dengan `Expanded` pada kolom teks, memastikan avatar, nama, dan NIM tidak meluap ke samping.
   - Kartu metrik mengisi lebar penuh dikurangi padding horizontal 16px, memberikan ruang baca yang lapang untuk angka dan judul metrik.

2. **Audit Dampak Aksesibilitas:**
   - **Status: Memenuhi Standar WCAG 2.1 AA & Flutter Accessibility Guidelines.**
   - **Semantics:** Setiap kartu informasi dibungkus widget `Semantics(label: 'Informasi $title adalah $value')` sehingga TalkBack / VoiceOver membacakan konteks data secara utuh, bukan sekadar potongan angka.
   - **Dynamic Type / Text Scaling:** Diuji dengan `platformDispatcher.textScaleFactorTestValue = 2.0` (pembesaran font 200%). Aplikasi tidak mengalami *RenderFlex overflow* karena teks di dalam kartu dapat melipat (*wrap*) secara fleksibel.
   - **Target Sentuh & Kontras:** Toggle tema menggunakan `CupertinoSwitch` dengan area sentuh yang mematuhi standar minimum $\ge 48 \times 48\text{ dp}$ serta skema warna adaptif Material 3 (`colorSchemeSeed: Colors.indigo`).

3. **Audit Ketersediaan Widget di Flutter Stable:**
   - **Status: 100% Menggunakan Widget Inti Stabil.**
   - Widget yang digunakan: `MaterialApp`, `ThemeData`, `Scaffold`, `AppBar`, `LayoutBuilder`, `ListView`, `GridView.count`, `Card`, `Padding`, `Row`, `Column`, `Expanded`, `CircleAvatar`, `Icon`, `CupertinoSwitch`, dan `Semantics`.
   - Tidak ada ketergantungan paket pihak ketiga yang berisiko deprecated. Seluruh widget didukung penuh pada saluran Flutter Stable saat ini (Flutter 3.x+).

---

## 5. Keputusan Arsitektur yang Dipilih & Rationale Teknis

Berdasarkan hasil komparasi prompt desain dan audit mandiri, keputusan teknis yang kami terapkan pada aplikasi dashboard ini adalah:

1. **Kombinasi `LayoutBuilder` + Dynamic Column Mapping:**
   Menggunakan `LayoutBuilder` untuk membaca `constraints.maxWidth` lokal dari parent secara reaktif, bukan mengandalkan `MediaQuery` global. Ketika `maxWidth < 700`, kartu ditata dalam 1 kolom agar nyaman dibaca pada perangkat mobile dengan satu tangan. Ketika `maxWidth >= 700`, kartu otomatis ditata dalam 2 kolom untuk efisiensi ruang layar tablet/desktop.
2. **Desain Komponen Reusable `InfoCard` dengan Semantics:**
   Membuat widget independen `InfoCard` yang mengonsumsi gaya warna dan tipografi langsung dari `Theme.of(context)` (mendukung *dynamic theme switching* seketika). Setiap kartu memiliki label `Semantics` deskriptif untuk aksesibilitas tunanetra.
3. **Pemberian `Expanded` yang Benar di dalam `Row` Kartu:**
   Di dalam `InfoCard`, judul metrik dibungkus dengan `Expanded` sementara nilai metrik berukuran intrinsik. Hal ini menjamin bahwa jika judul metrik bertambah panjang, teks judul akan melipat ke baris berikutnya tanpa mendesak nilai metrik ke luar layar.

---

## 6. Bukti Verifikasi Teknis (Automated Testing & QA)

Seluruh aspek responsivitas, interaksi, dan aksesibilitas telah diuji secara otomatis melalui rangkaian *Widget Test* pada file [`test/widget_test.dart`](test/widget_test.dart).

### Ringkasan Rangkaian Tes:
1. `Dashboard renders correctly and toggle theme works` — Menguji rendering elemen utama dan fungsionalitas switch tema.
2. `Responsive test: screen width below 600px (narrow mobile 360x800)` — Menguji ketahanan layout pada layar ponsel Android standar.
3. `Responsive test: ultra-narrow screen width (320x568)` — Menguji layout pada layar ultra kecil (setara iPhone SE generasi awal).
4. `Responsive test: screen width above breakpoint 700px (wide desktop/tablet 1024x768)` — Menguji adaptasi multi-kolom di layar besar.
5. `Accessibility test: high text scale factor (2.0x)` — Menguji aplikasi di bawah pembesaran font 200% tanpa adanya exception overflow.
6. `Accessibility test: Semantics labels are properly configured` — Memvalidasi keberadaan label semantik untuk Screen Reader.

### Log Eksekusi `flutter test`:
```text
00:00 +0: loading C:/Users/ainul/Documents/hello_world/test/widget_test.dart
00:00 +0: Dashboard renders correctly and toggle theme works
00:03 +1: Responsive test: screen width below 600px (narrow mobile 360x800)
00:03 +2: Responsive test: ultra-narrow screen width (320x568)
00:03 +3: Responsive test: screen width above breakpoint 700px (wide desktop/tablet 1024x768)
00:04 +4: Accessibility test: high text scale factor (2.0x)
00:04 +5: Accessibility test: Semantics labels are properly configured
00:04 +6: All tests passed!
```

### Log Eksekusi `flutter analyze`:
```text
Analyzing hello_world...
No issues found!
```

---

## 7. Panduan Menjalankan Proyek

### Menjalankan Aplikasi:
```bash
flutter run
```

### Menjalankan Pengujian Otomatis (Test Suite):
```bash
flutter test
```

### Menjalankan Analisis Statis Kode (Linter):
```bash
flutter analyze
```
