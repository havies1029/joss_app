import 'package:flutter/material.dart';
import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvcrud_form.dart';

class SppamvCrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const SppamvCrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} SPPA MV'),
				),
				body: SppamvCrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
