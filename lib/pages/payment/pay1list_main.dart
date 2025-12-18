import 'package:flutter/material.dart';
import 'package:joss_app/pages/payment/pay1list_list.dart';

class Pay1ListMainPage extends StatelessWidget {
	const Pay1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('Payment List'),
      ),
			backgroundColor: Colors.grey[100],
			body: const Pay1ListPage(),
		);
	}
}
