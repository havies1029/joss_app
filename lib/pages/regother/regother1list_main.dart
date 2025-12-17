import 'package:flutter/material.dart';
import 'package:joss_app/pages/regother/regother1list_list.dart';
import 'package:joss_app/pages/regother/regother1list_list_widget.dart';

class Regother1ListMainPage extends StatelessWidget {
	const Regother1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Reg Others'),
			),
			backgroundColor: Colors.grey[100],
			body: const Regother1ListPage(),
		);
	}
}
