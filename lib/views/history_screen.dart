import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historis')),
      body: const Center(
        child: Text('Riwayat Kesehatan, Detail Hasil, Obat, Biaya'),
      ),
    );
  }
}
