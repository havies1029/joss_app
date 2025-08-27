import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/repositories/combobox/combormatauang_repository.dart';

DropdownSearch<ComboRMatauangModel> buildFieldComboRMatauang({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboRMatauangModel>>? comboKey,
	ComboRMatauangModel? initItem,
	Function(ComboRMatauangModel?)? onChangedCallback,
	required Function(ComboRMatauangModel?) onSaveCallback,
	Function(ComboRMatauangModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboRMatauangModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboRMatauangRepository().getComboRMatauang();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboRMatauang,
			),
			compareFn: (item, sItem) => item.rmatauangKode == sItem.rmatauangKode,
			itemAsString: (item) {
				return item.rmatauangSimbol;
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

Widget itemBuilderComboRMatauang(
	BuildContext context, ComboRMatauangModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.rmatauangSimbol),
		),
	);
}
