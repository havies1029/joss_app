import 'package:joss_app/pages/gen_aset_par/asetparcari_list.dart';
import 'package:flutter/material.dart';

class AsetParCariMainPage extends StatelessWidget {
  const AsetParCariMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Ringkasan Par'),
      ),
      backgroundColor: Colors.grey[100],
      body: AsetParCariPage(),
    );
  }
}
