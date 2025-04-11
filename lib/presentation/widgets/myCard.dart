import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  const Mycard({Key? key, required this.title, required this.onPressed})
    : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(title), onTap: onPressed));
  }
}
