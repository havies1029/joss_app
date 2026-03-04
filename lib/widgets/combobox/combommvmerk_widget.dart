import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/repositories/combobox/combommvmerk_repository.dart';

DropdownSearch<ComboMMvmerkModel> buildFieldComboMMvmerk({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMMvmerkModel>>? comboKey,
	ComboMMvmerkModel? initItem,
	Function(ComboMMvmerkModel?)? onChangedCallback,
	required Function(ComboMMvmerkModel?) onSaveCallback,
	Function(ComboMMvmerkModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMMvmerkModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: 'merk ...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMMvmerkRepository().getComboMMvmerk(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMMvmerk,
			),
			compareFn: (item, sItem) => item.mmvmerkId == sItem.mmvmerkId,
			itemAsString: (item) {
				return item.nmMerk;
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

Widget itemBuilderComboMMvmerk(
	BuildContext context, ComboMMvmerkModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.nmMerk),
		),
	);
}
