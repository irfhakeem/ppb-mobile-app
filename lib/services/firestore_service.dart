import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_app/models/todo_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Todo>> getTodos() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Todo.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  Future<void> addTodo(Todo todo) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .add(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  Future<void> deleteTodo(String id) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(id)
        .delete();
  }
}
