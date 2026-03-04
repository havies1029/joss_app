import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/repositories/combobox/combomwarna_repository.dart';

DropdownSearch<ComboMWarnaModel> buildFieldComboMWarna({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMWarnaModel>>? comboKey,
	ComboMWarnaModel? initItem,
	Function(ComboMWarnaModel?)? onChangedCallback,
	required Function(ComboMWarnaModel?) onSaveCallback,
	Function(ComboMWarnaModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMWarnaModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMWarnaRepository().getComboMWarna(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMWarna,
			),
			compareFn: (item, sItem) => item.mwarnaId == sItem.mwarnaId,
			itemAsString: (item) {
				return item.warnaDesc;
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

Widget itemBuilderComboMWarna(
	BuildContext context, ComboMWarnaModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.warnaDesc),
		),
	);
}
