
import 'package:flutter/material.dart';

import 'asethullcari_list.dart';

class AsetHullCariMainPage extends StatelessWidget {
  const AsetHullCariMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Hull'),
      ),
      backgroundColor: Colors.grey[100],
      body: AsethullCariPage(),
    );
  }
}
