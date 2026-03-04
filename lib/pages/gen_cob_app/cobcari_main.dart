import 'package:joss_app/pages/gen_cob_app/cobcari_list.dart';
import 'package:flutter/material.dart';

class CobCariMainPage extends StatelessWidget {
	const CobCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List COB'),
      ),
			backgroundColor: Colors.grey[100],
			body: const CobCariPage(),
		);
	}
}
