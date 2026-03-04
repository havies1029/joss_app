import 'package:joss_app/pages/gen_aset_mv/asetmvcari_list.dart';
import 'package:flutter/material.dart';

class AsetMVCariMainPage extends StatelessWidget {
	const AsetMVCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Aset MV'),
      ),
			backgroundColor: Colors.grey[100],
			body: AsetMvCariPage(),
		);
	}
}
