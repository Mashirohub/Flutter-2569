import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task_model.dart';
import 'database_helper.dart';

class ShowContact extends StatefulWidget {
  const ShowContact({super.key});

  @override
  State<ShowContact> createState() => _ShowContactState();
}

class _ShowContactState extends State<ShowContact> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<List<Contact>> _fetchAllContacts() async {
    return await DatabaseHelper.instance.readAllContacts();
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  // ดูรายละเอียด (ปรับให้ตรงกับรูปที่ส่งมา)
  void viewContactDetails(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            contact.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldRow('First name', contact.firstName),
                if (contact.lastName.isNotEmpty)
                  _buildFieldRow('Last name', contact.lastName),
                if (contact.email.isNotEmpty)
                  _buildFieldRow('Email', contact.email),
                if (contact.phone.isNotEmpty)
                  _buildFieldRow('Phone', contact.phone),
                _buildFieldRow('Group', contact.groupName),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Back',
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
        ],
      ),
    );
  }

  // ยืนยันลบ
  void confirmDelete(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('ลบ ${contact.fullName} หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteContact(contact.id!);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ฟอร์มแก้ไข
  void showEditForm(Contact contact) {
    _firstNameController.text = contact.firstName;
    _lastNameController.text = contact.lastName;
    _emailController.text = contact.email;
    _phoneController.text = contact.phone;

    String selectedGroup = contact.groupName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('แก้ไขรายชื่อ'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First name'),
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last name'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedGroup,
                      decoration: const InputDecoration(labelText: 'Group'),
                      items: const [
                        DropdownMenuItem(value: 'Family', child: Text('Family')),
                        DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                        DropdownMenuItem(value: 'Work', child: Text('Work')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        if (value != null) setDialogState(() => selectedGroup = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
                  onPressed: () async {
                    final first = _firstNameController.text.trim();
                    if (first.isEmpty) return;

                    final updatedContact = Contact(
                      id: contact.id,
                      firstName: first,
                      lastName: _lastNameController.text.trim(),
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      groupName: selectedGroup,
                    );

                    await DatabaseHelper.instance.updateContact(updatedContact);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('บันทึก', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ฟอร์มเพิ่มรายชื่อ
  void showAddForm() {
    _clearForm();
    String selectedGroup = 'Family';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('เพิ่มรายชื่อ'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First name'),
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last name'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedGroup,
                      decoration: const InputDecoration(labelText: 'Group'),
                      items: const [
                        DropdownMenuItem(value: 'Family', child: Text('Family')),
                        DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                        DropdownMenuItem(value: 'Work', child: Text('Work')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        if (value != null) setDialogState(() => selectedGroup = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearForm();
                    setDialogState(() {});
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
                  onPressed: () async {
                    final first = _firstNameController.text.trim();
                    if (first.isEmpty) return;

                    final newContact = Contact(
                      firstName: first,
                      lastName: _lastNameController.text.trim(),
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      groupName: selectedGroup,
                    );

                    await DatabaseHelper.instance.insertContact(newContact);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Management'),
        backgroundColor: Colors.orange[300],
        foregroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<Contact>>(
        future: _fetchAllContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ยังไม่มีรายชื่อ'));
          }

          final contacts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return Card(
                color: Colors.orange[50],
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => viewContactDetails(contact),
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[200],
                    radius: 24,
                    child: Text(
                      contact.firstName.isNotEmpty ? contact.firstName[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  title: Text(
                    contact.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${contact.phone.isNotEmpty ? contact.phone + "\n" : ""}'
                        '${contact.email.isNotEmpty ? contact.email + " • " : ""}'
                        '${contact.groupName}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.blue),
                        tooltip: 'ดูข้อมูล',
                        onPressed: () => viewContactDetails(contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        tooltip: 'แก้ไข',
                        onPressed: () => showEditForm(contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'ลบ',
                        onPressed: () => confirmDelete(contact),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[700],
        child: const Icon(Icons.add),
        onPressed: showAddForm,
      ),
    );
  }
}