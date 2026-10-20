import 'dart:async';
import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  // Variable/State untuk menyimpan tanggal yang dipilih (default: hari ini)
  DateTime selectedDate = DateTime.now();

  // Fungsi untuk memunculkan kalender bawaan Flutter
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Tanggal awal yang disorot
      firstDate: DateTime(2015, 8), // Batas tahun paling bawah
      lastDate: DateTime(2101),     // Batas tahun paling atas
    );
    
    // Jika user memilih tanggal (tidak menekan cancel) dan tanggalnya berbeda
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Memperbarui state agar layar berubah
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Menampilkan tanggal ke layar (format YYYY-MM-DD)
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            // Tombol untuk memicu kalender
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Pilih Tanggal'),
            ),
          ],
        ),
      ),
    );
  }
}