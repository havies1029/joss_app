import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/models/combobox/combomjnsclient_model.dart';
import 'package:joss_app/repositories/combobox/combomjnsclient_repository.dart';

import '../apptheme/dropdown2.dart';

Widget buildFieldComboMJnsclient({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnsclientModel>>? comboKey,
	ComboMJnsclientModel? initItem,
	Function(ComboMJnsclientModel?)? onChangedCallback,
	required Function(ComboMJnsclientModel?) onSaveCallback,
	String? Function(ComboMJnsclientModel?)? validatorCallback,
}) {
	return ReusableComboBoxV2<ComboMJnsclientModel>(
		hintText: labelText,
		comboKey: comboKey,
		initItem: initItem,
		onChangedCallback: onChangedCallback,
		onSaveCallback: onSaveCallback,
		validatorCallback: validatorCallback,

		clientSideSearch: true,

		loader: (q) async {
			return await ComboMJnsclientRepository().getComboMJnsclient();
		},

		displayText: (item) => item.jenisNama,
		compareItems: (a, b) => a.mjnsclientId == b.mjnsclientId,
	);
}
