// ไฟล์: lib/home_page.dart
import 'package:flutter/material.dart';
import 'ex5.dart';
import 'ex6.dart'; // <--- 1. อย่าลืม Import ไฟล์ register ที่สร้างใหม่

class ex4 extends StatelessWidget {
  const ex4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawer Menu')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),

            // ... รายการเมนูอื่นๆ (Item 1 ฯลฯ) ...

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ex5()));
              },
            ),

            // --- 2. เพิ่มส่วนนี้ต่อจาก About us ---
            ListTile(
              leading: const Icon(Icons.person_add), // ไอคอนเพิ่มคน
              title: const Text('Register'), // ข้อความเมนู
              onTap: () {
                Navigator.pop(context); // ปิด Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ex6()), // ไปหน้า Register
                );
              },
            ),
            // ------------------------------------

          ],
        ),
      ),
      body: const Center(child: Text('หน้าหลัก')),
    );
  }
}