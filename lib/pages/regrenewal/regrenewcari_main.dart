import 'package:joss_app/pages/regrenewal/regrenewcari_list.dart';
import 'package:flutter/material.dart';

class RegRenewCariMainPage extends StatelessWidget {
	const RegRenewCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('RegEndors List'),
      ),
			backgroundColor: Colors.grey[100],
			body: const RegrenewCariPage(),
		);
	}
}
