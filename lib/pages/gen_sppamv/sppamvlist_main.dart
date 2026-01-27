import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvlist_list.dart';

class SppamvListMainPage extends StatelessWidget {
	const SppamvListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List SPPA MV'),
      ),
			backgroundColor: Colors.grey[100],
			body: const SppamvListPage(),
		);
	}
}
