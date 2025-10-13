import 'package:joss_app/pages/aset/aset_cari.dart';
import 'package:flutter/material.dart';

class AsetMainPage extends StatelessWidget {
	const AsetMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Aset'),
      ),
			backgroundColor: Colors.grey[100],
			body: AsetCariPage(),
		);
	}
}
