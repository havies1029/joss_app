import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_calmv/calmv1list_list.dart';

class Calmv1ListMainPage extends StatelessWidget {
	const Calmv1ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const Calmv1ListPage(),
		);
	}
}
