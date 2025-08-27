import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/repositories/combobox/combombentukcst_repository.dart';

DropdownSearch<ComboMBentukCstModel> buildFieldComboMBentukCst({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMBentukCstModel>>? comboKey,
	ComboMBentukCstModel? initItem,
	Function(ComboMBentukCstModel?)? onChangedCallback,
	required Function(ComboMBentukCstModel?) onSaveCallback,
	Function(ComboMBentukCstModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMBentukCstModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMBentukCstRepository().getComboMBentukCst();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMBentukCst,
			),
			compareFn: (item, sItem) => item.mbentukcstId == sItem.mbentukcstId,
			itemAsString: (item) {
				return item.bentukNama;
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

Widget itemBuilderComboMBentukCst(
	BuildContext context, ComboMBentukCstModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.bentukNama),
		),
	);
}
