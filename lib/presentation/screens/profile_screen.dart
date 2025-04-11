import 'package:medlink/presentation/widgets/myAppbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: MyAppBar(title: 'Profile', isFirstPage: true),
      ),
      body: const Center(child: Text('Detail Profile, Pengaturan, Logout')),
    );
  }
}
