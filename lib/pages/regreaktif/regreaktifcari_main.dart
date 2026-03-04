import 'package:joss_app/pages/regreaktif/regreaktifcari_list.dart';
import 'package:flutter/material.dart';

class RegReaktifCariMainPage extends StatelessWidget {
	const RegReaktifCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('RegReaktif List'),
      ),
			backgroundColor: Colors.grey[100],
			body: const RegreaktifCariPage(),
		);
	}
}
