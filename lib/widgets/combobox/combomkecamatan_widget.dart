import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';
import 'package:joss_app/repositories/combobox/combomkecamatan_repository.dart';

DropdownSearch<ComboMKecamatanModel> buildFieldComboMKecamatan({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMKecamatanModel>>? comboKey,
	ComboMKecamatanModel? initItem,
  required String kotaId,
	Function(ComboMKecamatanModel?)? onChangedCallback,
	required Function(ComboMKecamatanModel?) onSaveCallback,
	Function(ComboMKecamatanModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMKecamatanModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMKecamatanRepository().getComboMKecamatan(kotaId);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMKecamatan,
			),
			compareFn: (item, sItem) => item.mkecamatanId == sItem.mkecamatanId,
			itemAsString: (item) {
				return item.kecamatanNama;
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

Widget itemBuilderComboMKecamatan(
	BuildContext context, ComboMKecamatanModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kecamatanNama),
		),
	);
}
