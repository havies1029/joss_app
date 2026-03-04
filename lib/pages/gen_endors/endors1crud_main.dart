import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_endors/endors1crud_form.dart';

class Endors1CrudMainPage extends StatelessWidget {
	final String sppa1Id;
	const Endors1CrudMainPage({super.key, required this.sppa1Id});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('Tambah Endorsement'),
				),
				body: Endors1CrudFormPage(sppa1Id: sppa1Id),));
	}
}
