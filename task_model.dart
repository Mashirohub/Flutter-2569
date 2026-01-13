class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isDone;

  Task({this.id, required this.title, this.description, this.isDone = false});

  // แปลง Object เป็น Map เพื่อเก็บลงฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // SQLite ไม่รองรับ boolean โดยตรง
    };
  }

  // แปลง Map จากฐานข้อมูลกลับมาเป็น Object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
    );
  }
}