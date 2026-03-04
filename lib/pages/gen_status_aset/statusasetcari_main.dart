import 'package:joss_app/pages/gen_status_aset/statusasetcari_list.dart';
import 'package:flutter/material.dart';

class StatusasetcariMain extends StatelessWidget {
	const StatusasetcariMain({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List Status Aset'),
      ),
			backgroundColor: Colors.grey[100],
			body: const StatusAsetCariPage(),
		);
	}
}
