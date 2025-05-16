class Todo {
  String id;
  String title;
  String description;
  DateTime reminderDate;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'reminderDate': reminderDate.millisecondsSinceEpoch,
    'isDone': isDone,
  };

  factory Todo.fromMap(String id, Map<String, dynamic> map) => Todo(
    id: id,
    title: map['title'],
    description: map['description'],
    reminderDate: DateTime.fromMillisecondsSinceEpoch(map['reminderDate']),
    isDone: map['isDone'],
  );
}
