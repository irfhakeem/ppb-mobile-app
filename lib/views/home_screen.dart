import 'package:Medlink/components/myAppbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: Myappbar(title: 'Home', isFirstPage: true),
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
