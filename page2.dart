import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  final Function(String) onChanged;

  const Page2({super.key, required this.onChanged});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  String? _eduLevel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'ระดับการศึกษา',
        border: OutlineInputBorder(),
      ),
      value: _eduLevel,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาเลือกระดับการศึกษา';
        }
        return null;
      },
      items: const [
        'ประถมศึกษา',
        'มัธยมศึกษา',
        'ปริญญาตรี',
        'ปริญญาโท',
        'ปริญญาเอก',
      ].map((e) => DropdownMenuItem<String>(
        value: e,
        child: Text(e),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _eduLevel = value;
        });
        widget.onChanged(value!);
      },
    );
  }
}



