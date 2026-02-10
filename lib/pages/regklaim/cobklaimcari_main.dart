import 'package:joss_app/pages/regklaim/cobklaimcari_list.dart';
import 'package:flutter/material.dart';

class CobklaimcariMainPage extends StatelessWidget {
	const CobklaimcariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('COB Klaim Search'),
      ),
			backgroundColor: Colors.grey[100],
			body: const CobklaimcariPage(),
		);
	}
}
