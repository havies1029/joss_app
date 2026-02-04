import 'package:joss_app/pages/payment/historybayar2cari_list.dart';
import 'package:flutter/material.dart';

class Historybayar2CariMainPage extends StatelessWidget {
  final String inv1Id;
	const Historybayar2CariMainPage({super.key, required this.inv1Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Invoice'),
      ),
			backgroundColor: Colors.grey[100],
			body: Historybayar2CariPage(inv1Id: inv1Id),
		);
	} 
}
