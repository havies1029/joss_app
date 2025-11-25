import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/calpar/calpar1crud_form.dart';

class Calpar1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Calpar1CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} SPPA PAR'),
				),
				body: Calpar1CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
