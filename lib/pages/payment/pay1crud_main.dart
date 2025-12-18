import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/payment/pay1crud_form.dart';

class Pay1CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Pay1CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} Payment #1'),
				),
				body: Pay1CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
