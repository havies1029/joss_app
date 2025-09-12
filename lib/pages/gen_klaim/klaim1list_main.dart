import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_klaim/klaim1list_list.dart';

class Klaim1ListMainPage extends StatelessWidget {
	const Klaim1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const Klaim1ListPage(),
		);
	}
}
