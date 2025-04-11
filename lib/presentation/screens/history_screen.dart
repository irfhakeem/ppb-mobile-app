import 'package:medlink/presentation/widgets/myAppbar.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: MyAppBar(title: 'Histories', isFirstPage: true),
      ),
      body: const Center(
        child: Text('Riwayat Kesehatan, Detail Hasil, Obat, Biaya'),
      ),
    );
  }
}
