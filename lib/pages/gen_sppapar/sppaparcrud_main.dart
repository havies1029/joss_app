import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_sppapar/sppaparcrud_form.dart';

class SppaparCrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const SppaparCrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} SPPA PAR'),
				),
				body: SppaparCrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
