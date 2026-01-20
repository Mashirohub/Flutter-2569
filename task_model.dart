class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String groupName;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email = '',
    this.phone = '',
    required this.groupName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'groupName': groupName,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      groupName: map['groupName'] as String? ?? 'Other',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}