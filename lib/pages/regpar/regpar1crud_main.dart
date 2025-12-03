import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/regpar/regpar1crud_form.dart';

class Regpar1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Regpar1CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} SPPA PAR'),
				),
				body: Regpar1CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
