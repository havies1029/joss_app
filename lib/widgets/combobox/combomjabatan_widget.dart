import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';

import '../../common/constants.dart';

DropdownSearch<ComboMJabatanModel> buildFieldComboMJabatan({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJabatanModel>>? comboKey,
	ComboMJabatanModel? initItem,
	Function(ComboMJabatanModel?)? onChangedCallback,
	required Function(ComboMJabatanModel?) onSaveCallback,
	Function(ComboMJabatanModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJabatanModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJabatanRepository().getComboMJabatan();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
		popupProps: PopupPropsMultiSelection.modalBottomSheet(
			disableFilter: false,
			showSelectedItems: true,
			showSearchBox: true,
			itemBuilder: itemBuilderComboMJabatan,

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
			compareFn: (item, sItem) => item.mjabatanId == sItem.mjabatanId,
			itemAsString: (item) {
				return item.jabatanDesc;
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

Widget itemBuilderComboMJabatan(
	BuildContext context, ComboMJabatanModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.jabatanDesc, style: TextStyle(
				color: isSelected ? primaryColor : Colors.black, // ✅ di sini warna teks item
			),),
		),
	);
}
