# Assignment 3 - Muhammad Irfan Hakim (5025221291)

Berikut adalah branch untuk pekerjaan assigment 3 dengan tugas untuk mengimplementasikan notifikasi pada aplikasi mobile. Di aplikasi ini saya juga menggunakan firebase autentikasi dan firestore.

## Implementasi

### 1. Membuat Project di Firebase dan Install Keperluan untuk Firebase

Membuat project baru di [firebase console](https://console.firebase.google.com/u/0/).

Setelah membuat project, install dependencies dan jalankan command-command di bawah ini untuk memastikan Firebase bisa berjalan pada aplikasi flutternya.

```sh
# Login ke Firebase
Firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Install Flutter Core
flutter pub add firebase_core

# Konfigurasi flutterFire
flutterfire configure
```

Tambahkan kode berikut unutk inisialisasi Firebase menggunakan `DefaultFirebaseOptions` pada `lib/main.dart`.

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
```

Lebih lengkapnya untuk seluruh dependencies yang digunakan ada pada `pubspec.yaml` atau bisa dilihat di bawah ini.

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.13.0
  cloud_firestore: ^5.6.7
  firebase_auth: ^5.5.3
  awesome_notifications: ^0.10.1

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
```

### 2. Melakukan Konfigurasi Rules untuk Firestore dan Mengaktifkan Email/Password Auth

#### Konfigurasi Rules

Untuk membuat list todo tertampil sesuai dengan pengguna maka diperlukan koleksi tambahan yang berdasarkan dengan user yang nantinya diperoleh dari auth Firebase. Untuk melakukannya, bisa merubah rules menjadi seperti ini.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    match /users/{userId}/todos/{todoId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Aktifkan Email/Password

![image](https://github.com/user-attachments/assets/736db005-7d4d-4fd4-95c3-ea04670eb824)

### 3. Membuat Model dan Logika CRUD FireStore

Membuat model note sederhana yang berisikan title, description dan remainderDate untuk digunakan pada firestore.

```dart
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
```

dan untuk kebutuhan operasi CRUD, method ditulis pada `/lib/data/services/firestore_service.dart`

```dart
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
```

### 4. Membuat Service dan Page Auth

Untuk servie auth saya meniru dari dokumentasi yang diberikan di kelas yang bisa dilihat di `lib/services/auth_service.dart`. Sedangkan untuk Page Auth tergabung menjadi satu untuk login dan registernya seperti di bawah ini. Dimana setiap registrasi dan login akan muncul notifikasi langsung yang berisikan pesan sukses dan greetings untuk user.

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggle() {
    setState(() => _isLogin = !_isLogin);
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (_isLogin) {
        await _authService.signIn(email, password);
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id:
                (email.hashCode % 1000000) +
                (DateTime.now().millisecondsSinceEpoch % 1000000),
            channelKey: 'todo_channel',
            title: 'Welcome back!',
            body: 'You have successfully logged in as $email',
          ),
        );
      } else {
        await _authService.register(email, password);
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id:
                (email.hashCode % 1000000) +
                (DateTime.now().millisecondsSinceEpoch % 1000000),
            channelKey: 'todo_channel',
            title: 'Thank you for registering!',
            body: 'Welcome to the Todo Reminder App $email',
          ),
        );
      }
    } catch (e) {
      final message = e is FirebaseAuthException ? e.message : e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: _toggle,
              child: Text(
                _isLogin ? "Create new account" : "I have an account",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Screenshot 2025-05-16 225841](https://github.com/user-attachments/assets/991c993d-8177-4a93-a18a-b10cd1a77398)

### 5. Home Page dan Schedule Notifikasi

Pada bagian home page berisikan list dari notes yang sudah dibuat dan user bisa melakukan create, update dan delete. Ketika user membuat sebuah note baru maka akan trigger schedule notification (disclaimer: shchedule notification selalu telat muncul +- 5 menit sama seperti waktu di kelas). Untuk pembuatan note sekaligus notifikasinya seperti di bawah ini

```dart
// ...
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
// ...
```

![Screenshot 2025-05-16 225748](https://github.com/user-attachments/assets/44b2785f-3281-4e3e-9fce-3938f966da52)

## Referensi

[FireBase Auth - Dokumentasi Kelas](https://github.com/agusbudi/mobile-programming/tree/main/09.%20Firebase%20Auth)

[Notification- Dokumentasi Kelas](https://github.com/agusbudi/mobile-programming/tree/main/10.%20Awesome%20Notifications)

[Integrasi User dengan Firestore - ChatGPT](https://chatgpt.com)
