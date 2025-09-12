import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_klaim/klaim2crud_form.dart';

class Klaim2CrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const Klaim2CrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} Klaim 2'),
				),
				body: Klaim2CrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
