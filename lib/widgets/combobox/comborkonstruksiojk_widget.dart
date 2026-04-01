import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/repositories/combobox/comborkonstruksiojk_repository.dart';

DropdownSearch<ComboRKonstruksiojkModel> buildFieldComboRKonstruksiojk({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>? comboKey,
	ComboRKonstruksiojkModel? initItem,
	Function(ComboRKonstruksiojkModel?)? onChangedCallback,
	required Function(ComboRKonstruksiojkModel?) onSaveCallback,
	Function(ComboRKonstruksiojkModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboRKonstruksiojkModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboRKonstruksiojkRepository().getComboRKonstruksiojk(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboRKonstruksiojk,
			),
			compareFn: (item, sItem) => item.rkonstruksiojkId == sItem.rkonstruksiojkId,
			itemAsString: (item) {
				return item.kelasNama;
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

Widget itemBuilderComboRKonstruksiojk(
	BuildContext context, ComboRKonstruksiojkModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kelasNama),
		),
	);
}
