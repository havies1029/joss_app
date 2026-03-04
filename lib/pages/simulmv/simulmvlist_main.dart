import 'package:flutter/material.dart';
import 'package:joss_app/pages/simulmv/simulmvlist_list.dart';

class SimulmvListMainPage extends StatelessWidget {
	const SimulmvListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const SimulmvListPage(),
		);
	}
}
