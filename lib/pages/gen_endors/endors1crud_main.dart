import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_endors/endors1crud_form.dart';

class Endors1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	final dynamic? data;

	const Endors1CrudMainPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		this.data,
	});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah" ? "Tambah" : "Ubah"} Endorsement'),
				),
				body: Endors1CrudFormPage(
					viewMode: viewMode,
					recordId: recordId,
					data: data,
				),
			),
		);
	}
}
