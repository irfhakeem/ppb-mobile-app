import 'package:Medlink/components/myBottom_nav.dart';
import 'package:Medlink/views/fasility_screen.dart';
import 'package:Medlink/views/history_screen.dart';
import 'package:Medlink/views/home_screen.dart';
import 'package:Medlink/views/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.from(
          alpha: 1.0,
          red: 0.9568627450980393,
          green: 0.9529411764705882,
          blue: 0.9882352941176471,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Daftar halaman untuk setiap tab
  final List<Widget> _pages = [
    HomeScreen(),
    FasilityScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 75.0,
        child: BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
      ),
    );
  }
}
