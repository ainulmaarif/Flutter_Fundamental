import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  const MyImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      // Nama file di bawah ini wajib sama persis dengan yang ada di Explorer dan pubspec
      image: AssetImage("assets/logo.jpeg"), 
    );
  }
}