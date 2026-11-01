import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/product_page.dart';
import 'pages/stats_page.dart';
import 'pages/todo_page.dart';

void main() {
  // ProviderScope membungkus root widget aplikasi untuk menyediakan state Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 5 - AsyncValue Riverpod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const ProductPage(),
      routes: {
        '/stats': (context) => const StatsPage(),
        '/todo': (context) => const TodoPage(),
        '/product': (context) => const ProductPage(),
      },
    );
  }
}

