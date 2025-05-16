import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_note_app/services/auth_service.dart';

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
