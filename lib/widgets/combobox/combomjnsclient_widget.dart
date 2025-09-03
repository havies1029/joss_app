import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjnsclient_model.dart';
import 'package:joss_app/repositories/combobox/combomjnsclient_repository.dart';

import '../../common/constants.dart';

DropdownSearch<ComboMJnsclientModel> buildFieldComboMJnsclient({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnsclientModel>>? comboKey,
	ComboMJnsclientModel? initItem,
	Function(ComboMJnsclientModel?)? onChangedCallback,
	required Function(ComboMJnsclientModel?) onSaveCallback,
	Function(ComboMJnsclientModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJnsclientModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJnsclientRepository().getComboMJnsclient();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
		popupProps: PopupPropsMultiSelection.modalBottomSheet(
			disableFilter: false,
			showSelectedItems: true,
			showSearchBox: true,
			itemBuilder: itemBuilderComboMJnsclient,

			// 🔎 styling kotak filter
			searchFieldProps: TextFieldProps(
				style: const TextStyle(color: Colors.black),      // teks hitam
				cursorColor: Colors.black,
				decoration: InputDecoration(
					hintText: 'Cari provinsi…',
					hintStyle: const TextStyle(color: Colors.black54),
					filled: true,
					fillColor: Colors.white,                        // background putih biar kontras
					prefixIcon: const Icon(Icons.search, color: Colors.black),
					contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
					enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(10),
						borderSide: const BorderSide(color: Colors.black), // border hitam
					),
					focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(10),
						borderSide: const BorderSide(color: Colors.black, width: 1.5), // border hitam tebal saat fokus
					),
				),
			),

			// opsional: warna background sheet popup
			modalBottomSheetProps: const ModalBottomSheetProps(
				backgroundColor: Colors.white,
			),
		),
			compareFn: (item, sItem) => item.mjnsclientId == sItem.mjnsclientId,
			itemAsString: (item) {
				return item.jenisNama;
			},
			onChanged: (value) {
				if (onChangedCallback != null) {
					onChangedCallback(value);
				}
			},
			onSaved: (value) {
				onSaveCallback(value);
			},
			validator: (value) {
				if (validatorCallback != null) {
					validatorCallback(value);
					if (value == null) {
						return "";
					}
				}
				return null;
			},
		);
}

Widget itemBuilderComboMJnsclient(
	BuildContext context, ComboMJnsclientModel item, bool isSelected, bool isDisabled) {
	return Container(
		margin: const EdgeInsets.symmetric(horizontal: 8),
		decoration: !isSelected
			? null
			: BoxDecoration(
				border: Border.all(color: Theme.of(context).primaryColor),
				borderRadius: BorderRadius.circular(5),
				color: Colors.white,
			),
		child: ListTile(
			selected: isSelected,
			title: Text(
				item.jenisNama,
				style: TextStyle(
				color: isSelected ? primaryColor : Colors.black, // ✅ di sini warna teks item
			),),
		),
	);
}
