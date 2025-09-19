import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/models/combobox/combomjnsclient_model.dart';
import 'package:joss_app/repositories/combobox/combomjnsclient_repository.dart';

import '../../common/constants.dart';

/// 🔹 Wrapper khusus untuk Combo MJnsclient
Widget buildFieldComboMJnsclient({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnsclientModel>>? comboKey,
	ComboMJnsclientModel? initItem,
	Function(ComboMJnsclientModel?)? onChangedCallback,
	required Function(ComboMJnsclientModel?) onSaveCallback,
	String? Function(ComboMJnsclientModel?)? validatorCallback,
}) {
	return ReusableComboBox<ComboMJnsclientModel>(
		hintText: labelText,
		searchHintText: "Cari jenis client…",
		comboKey: comboKey,
		initItem: initItem,
		onChangedCallback: onChangedCallback,
		onSaveCallback: onSaveCallback,
		validatorCallback: validatorCallback,

		// Loader data (API/Repo)
		dataLoader: () async {
			return await ComboMJnsclientRepository().getComboMJnsclient();
		},

		// Teks yang ditampilkan
		displayText: (item) => item.jenisNama,

		// Cara compare antar item
		compareItems: (a, b) => a.mjnsclientId == b.mjnsclientId,
	);
}
