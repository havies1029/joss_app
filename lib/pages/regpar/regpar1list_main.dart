import 'package:flutter/material.dart';
import 'package:joss_app/pages/regpar/regpar1list_list.dart';

class Regpar1ListMainPage extends StatelessWidget {
	const Regpar1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Registrasi PAR"),
			),
			backgroundColor: Colors.grey[100],
			body: const Regpar1ListPage(),
		);
	}
}
