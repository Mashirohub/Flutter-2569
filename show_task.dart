import 'package:flutter/material.dart';
import 'task_model.dart';
import 'database_helper.dart';

class ShowTask extends StatefulWidget {
  const ShowTask({super.key});

  @override
  State<ShowTask> createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // ฟังก์ชันสำหรับแสดง Dialog เพิ่มงาน
  void showInsertTaskForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final task = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                );

                await DatabaseHelper.instance.insertTask(task);

                _titleController.clear();
                _descriptionController.clear();

                Navigator.pop(context); // ปิด dialog
                setState(() {}); // refresh หน้าจอ
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Colors.lime,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInsertTaskForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

