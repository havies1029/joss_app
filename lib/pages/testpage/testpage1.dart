import 'package:flutter/material.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) => ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text('Laporan #$i'),
        subtitle: const Text('Deskripsi singkat...'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}