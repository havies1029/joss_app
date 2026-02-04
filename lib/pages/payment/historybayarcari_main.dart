import 'package:joss_app/pages/payment/historybayarcari_list.dart';
import 'package:flutter/material.dart';

class HistorybayarCariMainPage extends StatelessWidget {
	const HistorybayarCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('History Bayar List'),
      ),
			backgroundColor: Colors.grey[100],
			body: const HistorybayarCariPage(),
		);
	}
}
