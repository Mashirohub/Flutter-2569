import 'package:flutter/material.dart';
import 'ex3.dart';

class ex2 extends StatelessWidget {
  const ex2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าที่ 1'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'หน้าที่ 2',
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('<< Back', style: TextStyle(fontSize: 18)),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ex3()),
                );
              },
              child: const Text('ไปหน้าที่ 3 >>', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}