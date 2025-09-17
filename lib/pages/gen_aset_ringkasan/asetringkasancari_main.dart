import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list.dart';
import 'package:flutter/material.dart';

class AsetRingkasanCariMainPage extends StatelessWidget {
	const AsetRingkasanCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Ringkasan Aset'),
      ),
			backgroundColor: Colors.grey[100],
			body: AsetRingkasanCariPage(),
		);
	}
}
