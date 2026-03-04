import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomstsaset_model.dart';
import 'package:joss_app/repositories/combobox/combomstsaset_repository.dart';

DropdownSearch<ComboMStsasetModel> buildFieldComboMStsaset({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMStsasetModel>>? comboKey,
	ComboMStsasetModel? initItem,
	Function(ComboMStsasetModel?)? onChangedCallback,
	required Function(ComboMStsasetModel?) onSaveCallback,
	Function(ComboMStsasetModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMStsasetModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMStsasetRepository().getComboMStsaset();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMStsaset,
			),
			compareFn: (item, sItem) => item.mstatusasetId == sItem.mstatusasetId,
			itemAsString: (item) {
				return item.statusNama;
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

Widget itemBuilderComboMStsaset(
	BuildContext context, ComboMStsasetModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.statusNama),
		),
	);
}
