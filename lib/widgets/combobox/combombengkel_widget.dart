import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/repositories/combobox/combombengkel_repository.dart';

DropdownSearch<ComboMBengkelModel> buildFieldComboMBengkel({
	required String labelText,
  required String mwilayahbengkelId,
	GlobalKey<DropdownSearchState<ComboMBengkelModel>>? comboKey,
	ComboMBengkelModel? initItem,
	Function(ComboMBengkelModel?)? onChangedCallback,
	required Function(ComboMBengkelModel?) onSaveCallback,
	Function(ComboMBengkelModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMBengkelModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMBengkelRepository().getComboMBengkel(mwilayahbengkelId, filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMBengkel,
			),
			compareFn: (item, sItem) => item.mbengkelId == sItem.mbengkelId,
			itemAsString: (item) {
				return item.bengkelNama;
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

Widget itemBuilderComboMBengkel(
	BuildContext context, ComboMBengkelModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.bengkelNama),
		),
	);
}
