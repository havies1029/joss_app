import 'package:flutter/material.dart';

import 'dn1cari_list.dart';

class Dn1cariMain extends StatelessWidget {
  const Dn1cariMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List COB'),
      ),
      backgroundColor: Colors.grey[100],
      body: const Dn1CariPage(sppa1Id: 'SPPA/MV250700001',),
    );
  }
}
