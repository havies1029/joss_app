import 'package:joss_app/pages/gen_aset_dashboard/asetdashboardcari_list.dart';
import 'package:flutter/material.dart';

class AsetDashboardCariMainPage extends StatelessWidget {
	const AsetDashboardCariMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('List COB'),
      ),
			backgroundColor: Colors.grey[100],
			body: AsetDashboardCariPage(),
		);
	}
}
