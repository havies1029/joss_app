import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/repositories/combobox/combombiindemnityojk_repository.dart';

DropdownSearch<ComboMBiindemnityOjkModel> buildFieldComboMBiindemnityOjk({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMBiindemnityOjkModel>>? comboKey,
	ComboMBiindemnityOjkModel? initItem,
	Function(ComboMBiindemnityOjkModel?)? onChangedCallback,
	required Function(ComboMBiindemnityOjkModel?) onSaveCallback,
	Function(ComboMBiindemnityOjkModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMBiindemnityOjkModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMBiindemnityOjkRepository().getComboMBiindemnityOjk();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: true)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMBiindemnityOjk,
			),
			compareFn: (item, sItem) => item.mbiindemnityojkId == sItem.mbiindemnityojkId,
			itemAsString: (item) {
				return item.keterangan;
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

Widget itemBuilderComboMBiindemnityOjk(
	BuildContext context, ComboMBiindemnityOjkModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.keterangan),
		),
	);
}
