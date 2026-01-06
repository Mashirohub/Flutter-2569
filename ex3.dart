import 'package:flutter/material.dart';

class ex3 extends StatelessWidget {
  const ex3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าที่ 2'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'หน้าที่ 3',
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('<< Back', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}