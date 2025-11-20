import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_regmv/regmv1crud_form.dart';

class Regmv1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Regmv1CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} SPPA MV'),
				),
				body: Regmv1CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
