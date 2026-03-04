import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';
import 'package:joss_app/repositories/combobox/combomwilayahbengkel_repository.dart';

DropdownSearch<ComboMWilayahBengkelModel> buildFieldComboMWilayahBengkel({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMWilayahBengkelModel>>? comboKey,
	ComboMWilayahBengkelModel? initItem,
	Function(ComboMWilayahBengkelModel?)? onChangedCallback,
	required Function(ComboMWilayahBengkelModel?) onSaveCallback,
	Function(ComboMWilayahBengkelModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMWilayahBengkelModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMWilayahBengkelRepository().getComboMWilayahBengkel(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMWilayahBengkel,
			),
			compareFn: (item, sItem) => item.mwilayahbengkelId == sItem.mwilayahbengkelId,
			itemAsString: (item) {
				return item.wilayahNama;
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

Widget itemBuilderComboMWilayahBengkel(
	BuildContext context, ComboMWilayahBengkelModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.wilayahNama),
		),
	);
}
