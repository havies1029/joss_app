import 'package:joss_app/pages/gen_promo/promo1cari_list.dart';
import 'package:flutter/material.dart';

class Promo1cariMainPage extends StatelessWidget {
	const Promo1cariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Promo'),
      ),
			backgroundColor: Colors.grey[100],
			body: const Promo1CariPage(),
		);
	}
}
