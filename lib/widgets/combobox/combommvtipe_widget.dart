import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/repositories/combobox/combommvtipe_repository.dart';

DropdownSearch<ComboMMvtipeModel> buildFieldComboMMvtipe({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMMvtipeModel>>? comboKey,
	ComboMMvtipeModel? initItem,
	required String mvmerkId,
	Function(ComboMMvtipeModel?)? onChangedCallback,
	required Function(ComboMMvtipeModel?) onSaveCallback,
	Function(ComboMMvtipeModel?)? validatorCallback
}) {
	return DropdownSearch<ComboMMvtipeModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: 'tipe ...',
				labelText: labelText,
			),
		),
		items: (filter, infiniteScrollProps) async {
			return ComboMMvtipeRepository().getComboMMvtipe(mvmerkId, filter);
		},
		suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
		popupProps: const PopupPropsMultiSelection.modalBottomSheet(
			disableFilter: true,
			showSelectedItems: true,
			showSearchBox: true,
			itemBuilder: itemBuilderComboMMvtipe,
		),
		compareFn: (item, sItem) => item.mmvtipeId == sItem.mmvtipeId,
		itemAsString: (item) {
			return item.nmTipe;
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

Widget itemBuilderComboMMvtipe(
		BuildContext context, ComboMMvtipeModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.nmTipe),
		),
	);
}