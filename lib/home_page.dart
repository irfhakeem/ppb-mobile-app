import 'package:firebase_note_app/services/auth_service.dart';
import 'package:firebase_note_app/services/firestore_service.dart';
import 'package:firebase_note_app/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  void _logout() async {
    await _authService.signOut();
  }

  void _showAddTodoDialog() {
    String title = '';
    String description = '';
    DateTime? reminderDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Todo"),
          content: StatefulBuilder(
            builder:
                (context, setStateDialog) => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: "Title"),
                        onChanged: (val) => title = val,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Description"),
                        onChanged: (val) => description = val,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text(
                          reminderDate == null
                              ? "Pick Reminder Date"
                              : reminderDate.toString(),
                        ),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setStateDialog(() {
                                reminderDate = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && reminderDate != null) {
                  final todo = Todo(
                    id: '',
                    title: title,
                    description: description,
                    reminderDate: reminderDate!,
                  );
                  _firestoreService.addTodo(todo);

                  // Schedule notification
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: DateTime.now().millisecondsSinceEpoch.remainder(
                        100000,
                      ),
                      channelKey: 'todo_reminder_channel',
                      title: 'Reminder: $title',
                      body: description,
                    ),
                    schedule: NotificationCalendar.fromDate(
                      date: reminderDate!,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${todo.description}\nReminder: ${todo.reminderDate.toLocal().toString().substring(0, 16)}',
      ),
      isThreeLine: true,
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Edit Todo"),
                      content: StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Title",
                                  ),
                                  controller: TextEditingController(
                                    text: todo.title,
                                  ),
                                  onChanged: (val) => todo.title = val,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Description",
                                  ),
                                  controller: TextEditingController(
                                    text: todo.description,
                                  ),
                                  onChanged: (val) => todo.description = val,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _firestoreService.updateTodo(todo);
                            Navigator.pop(context);
                          },
                          child: Text("Update"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Checkbox(
              value: todo.isDone,
              onChanged: (val) {
                todo.isDone = val ?? false;
                _firestoreService.updateTodo(todo);
              },
            ),
          ],
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete Todo"),
              content: Text("Are you sure you want to delete this todo?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _firestoreService.deleteTodo(todo.id);
                    Navigator.pop(context);
                  },
                  child: Text("Delete"),
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
        title: Text("Todo Reminder"),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _firestoreService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error loading todos"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!;
          if (todos.isEmpty) return Center(child: Text("No todos found"));

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => _buildTodoItem(todos[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
