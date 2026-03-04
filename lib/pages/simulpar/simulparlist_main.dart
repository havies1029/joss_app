import 'package:flutter/material.dart';
import 'package:joss_app/pages/simulpar/simulparlist_list.dart';

class SimulparListMainPage extends StatelessWidget {
	const SimulparListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const SimulparListPage(),
		);
	}
}
