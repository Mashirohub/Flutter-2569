import 'package:flutter/material.dart';
import 'ex2.dart';
import 'ex3.dart';

class ex1 extends StatelessWidget {
  const ex1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop7_1'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Home Page',
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ex2()),
                );
              },
              child: const Text('ไปหน้าที่ 2 >>', style: TextStyle(fontSize: 18)),
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