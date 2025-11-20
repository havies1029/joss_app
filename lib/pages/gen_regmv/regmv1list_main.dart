import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_regmv/regmv1list_list.dart';

class Regmv1ListMainPage extends StatelessWidget {
	const Regmv1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const Regmv1ListPage(),
		);
	}
}
