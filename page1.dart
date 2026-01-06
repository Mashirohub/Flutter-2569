import 'package:flutter/material.dart';
import 'page2.dart';
import 'page3.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<Page1> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _eduLevel = '';
  String _province = '';

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

              // --- ช่องเดิม ---
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                value == null || value.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'อีเมล'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value ?? '',
                validator: (value) =>
                value == null || !value.contains('@')
                    ? 'กรุณากรอกอีเมลให้ถูกต้อง'
                    : null,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
                validator: (value) =>
                value == null || value.length < 6
                    ? 'รหัสผ่านต้องอย่างน้อย 6 ตัวอักษร'
                    : null,
              ),

              const SizedBox(height: 16),

              Page2(
                onChanged: (value) {
                  _eduLevel = value;
                },
              ),

              const SizedBox(height: 16),

              Page3(
                onChanged: (value) {
                  _province = value;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
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
                child: const Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




