import 'package:medlink/presentation/widgets/myAppbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: MyAppBar(title: 'Home', isFirstPage: true),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [Container(), Container()]),
      ),
    );
  }
}
