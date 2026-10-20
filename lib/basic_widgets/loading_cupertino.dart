import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Wajib di-import untuk widget ala iOS

class LoadingCupertino extends StatelessWidget {
  const LoadingCupertino({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        margin: const EdgeInsets.only(top: 30),
        color: Colors.white,
        child: Column(
          children: [
            CupertinoButton(
              child: const Text("Contoh button"),
              onPressed: () {},
            ),
            const CupertinoActivityIndicator(), // Ini akan memunculkan animasi loading khas iPhone
          ],
        ),
      ),
    );
  }
}