import 'package:flutter/material.dart';

import '../../widgets/mobiledesign_widget.dart';
import '../profilepage/mobile/profile/form_section/rekan_bank.dart';

class MRekanBankCrudMainPage extends StatelessWidget {
	final String viewMode;
	final String recordId;
	const MRekanBankCrudMainPage({super.key, required this.viewMode, required this.recordId});

	@override
	Widget build(BuildContext context) {
		return MobileDesignWidget(
			child: Scaffold(
				appBar: AppBar(
					title: Text('${viewMode == "tambah"?"Tambah":"Ubah"} Informasi Bank'),
				),
				body: MRekanBankCrudFormPage(viewMode: viewMode, recordId: recordId)));
	}
}
