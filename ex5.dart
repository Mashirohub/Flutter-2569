import 'package:flutter/material.dart';

class ex5 extends StatelessWidget {
  const ex5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
      ),
      body: const Center(
        child: Text(
          'About us',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}