import 'package:joss_app/pages/klaimlacak/klaimprogresscari_list.dart';
import 'package:flutter/material.dart';

class KlaimProgressCariMainPage extends StatelessWidget {
	final String klaim1Id;
	const KlaimProgressCariMainPage({super.key, required this.klaim1Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Klaim Progress List'),
			),
			backgroundColor: Colors.grey[100],
			body: KlaimprogresscariPage(klaim1Id: klaim1Id),
		);
	}
}