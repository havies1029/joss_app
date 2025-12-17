import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/regother/regother1crud_form.dart';

class Regother1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Regother1CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
				child: Scaffold(
						appBar: AppBar(
							title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} Reg Other'),
						),
						body: Regother1CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
