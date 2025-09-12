import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_klaim/klaim2list_list.dart';

class Klaim2ListMainPage extends StatelessWidget {
	const Klaim2ListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[100],
			body: const Klaim2ListPage(),
		);
	}
}
