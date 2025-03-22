import 'package:flutter/material.dart';

class FasilityScreen extends StatelessWidget {
  const FasilityScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facility')),
      body: const Center(child: Text('Pilih Fasilitas, Booking Fasilitas')),
    );
  }
}
