import 'package:flutter/material.dart';

// Fungsi main() adalah fungsi pertama yang dijalankan oleh Flutter
void main() {
  runApp(const AplikasiSaya());
}

// Ini adalah kerangka utama aplikasi kita
class AplikasiSaya extends StatelessWidget {
  const AplikasiSaya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan pita tulisan "DEBUG" di pojok
      title: 'Latihan Tampilan',
      
      // Scaffold adalah kanvas layar putih dasar kita
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Latihan Menyusun Kotak'),
          backgroundColor: Colors.blue, // Warna bagian atas aplikasi
        ),
        // Body adalah isi layarnya. Saat ini kita isi teks di tengah (Center)
        body: const Center(
          child: Text('Kanvas kita masih kosong!'),
        ),
      ),
    );
  }
}