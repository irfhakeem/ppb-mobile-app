import 'package:medlink/presentation/widgets/myAppbar.dart';
import 'package:flutter/material.dart';

class FasilityScreen extends StatelessWidget {
  const FasilityScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: MyAppBar(title: 'Facilities', isFirstPage: true),
      ),
      body: const Center(child: Text('Pilih Fasilitas, Booking Fasilitas')),
    );
  }
}
