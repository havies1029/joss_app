import 'package:joss_app/pages/regreaktif/regreaktif1_form.dart';
import 'package:flutter/material.dart';

class Regreaktif1FormMainPage extends StatelessWidget {
	final String sppa1Id;
	const Regreaktif1FormMainPage({super.key, required this.sppa1Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				appBar: AppBar(
					title: Text('Tambah Renewal'),
				),
				body: Regreaktif1FormPage(sppa1Id: sppa1Id),);
	}
}
