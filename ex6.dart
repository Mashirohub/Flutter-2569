import 'package:flutter/material.dart';

class ex6 extends StatefulWidget {
  const ex6({super.key});

  @override
  State<ex6> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<ex6> {
  final _formKey = GlobalKey<FormState>(); // คีย์สำหรับตรวจสอบฟอร์ม

  String _name = '';
  String _email = '';
  String _password = '';
  String _eduLevel = 'ปริญญาตรี'; // ค่าเริ่มต้น
  String _province = 'กรุงเทพฯ'; // ค่าเริ่มต้น

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- ชื่อ ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                value == null || value.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 16),

              // --- อีเมล ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
                validator: (value) => value == null || !value.contains('@')
                    ? 'กรุณากรอกอีเมลให้ถูกต้อง'
                    : null,
              ),
              const SizedBox(height: 16),

              // --- รหัสผ่าน ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
                validator: (value) => value == null || value.length < 6
                    ? 'รหัสผ่านต้องอย่างน้อย 6 ตัวอักษร'
                    : null,
              ),
              const SizedBox(height: 16),

              // --- ระดับการศึกษา (แทน Page2) ---
              DropdownButtonFormField<String>(
                value: _eduLevel,
                decoration: const InputDecoration(
                  labelText: 'ระดับการศึกษา',
                  border: OutlineInputBorder(),
                ),
                items: ['มัธยมปลาย', 'ปริญญาตรี', 'ปริญญาโท', 'ปริญญาเอก']
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _eduLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // --- จังหวัด (แทน Page3) ---
              DropdownButtonFormField<String>(
                value: _province,
                decoration: const InputDecoration(
                  labelText: 'จังหวัด',
                  border: OutlineInputBorder(),
                ),
                items: ['กรุงเทพฯ', 'เชียงใหม่', 'ขอนแก่น', 'ภูเก็ต']
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _province = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // --- ปุ่มสมัครสมาชิก ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'สมัครสมาชิกสำเร็จ\n'
                                'ชื่อ: $_name\n'
                                'อีเมล: $_email\n'
                                'การศึกษา: $_eduLevel\n'
                                'จังหวัด: $_province',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('ยืนยันการสมัคร', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}