import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('الصادق موبايل'),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'مرحباً بك! تم تحديث التطبيق بنجاح.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
