import 'package:joss_app/pages/gen_aset_health/asethealthcari_list.dart';
import 'package:flutter/material.dart';

class AsetHealthCariMainPage extends StatelessWidget {
	const AsetHealthCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Aset Kesehatan'),
      ),
			backgroundColor: Colors.grey[100],
			body: AsetHealthCariPage(),
		);
	}
}
