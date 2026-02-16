import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/repositories/combobox/combominsurer_repository.dart';

DropdownSearch<ComboMInsurerModel> buildFieldComboMInsurer({
	required String labelText,
  required bool enabled,
	GlobalKey<DropdownSearchState<ComboMInsurerModel>>? comboKey,
	ComboMInsurerModel? initItem,
	Function(ComboMInsurerModel?)? onChangedCallback,
	required Function(ComboMInsurerModel?) onSaveCallback,
	Function(ComboMInsurerModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMInsurerModel>(
    enabled: enabled,
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMInsurerRepository().getComboMInsurer(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMInsurer,
			),
			compareFn: (item, sItem) => item.minsurerId == sItem.minsurerId,
			itemAsString: (item) {
				return item.insurerNama;
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

Widget itemBuilderComboMInsurer(
	BuildContext context, ComboMInsurerModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.insurerNama),
		),
	);
}
