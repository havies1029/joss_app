import 'package:joss_app/pages/regendors/regendors1form_form.dart';
import 'package:flutter/material.dart';

class RegEndors1FormMainPage extends StatelessWidget {
	final String sppa1Id;
  final String sppa2Id;
	const RegEndors1FormMainPage({super.key, required this.sppa1Id, required this.sppa2Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				appBar: AppBar(
					title: Text('Tambah Endorsement'),
				),
				body: Regendors1FormFormPage(sppa1Id: sppa1Id, sppa2Id: sppa2Id),);
	}
}
