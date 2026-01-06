import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  final Function(String) onChanged;

  const Page3({super.key, required this.onChanged});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String? _province;

  final List<String> _provinces = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'ขอนแก่น',
    'เชียงใหม่',
    'เชียงราย',
    'ชลบุรี',
    'นครปฐม',
    'นครราชสีมา',
    'นนทบุรี',
    'ปทุมธานี',
    'ภูเก็ต',
    'ระยอง',
    'สงขลา',
    'สุราษฎร์ธานี',
    'อุบลราชธานี',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'จังหวัด',
        border: OutlineInputBorder(),
      ),
      value: _province,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาเลือกจังหวัด';
        }
        return null;
      },
      items: _provinces
          .map(
            (e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          _province = value;
        });
        widget.onChanged(value!);
      },
    );
  }
}

