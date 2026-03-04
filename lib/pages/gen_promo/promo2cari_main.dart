import 'package:joss_app/pages/gen_promo/promo2cari_list.dart';
import 'package:flutter/material.dart';

class Promo2cariMainPage extends StatelessWidget {
  final String promo1Id;
	const Promo2cariMainPage({super.key, required this.promo1Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Promo'),
      ),
			backgroundColor: Colors.grey[100],
			body: Promo2CariPage(promo1Id: promo1Id),
		);
	}
}
