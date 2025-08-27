import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommop_model.dart';
import 'package:joss_app/repositories/combobox/combommop_repository.dart';

DropdownSearch<ComboMMopModel> buildFieldComboMMop({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMMopModel>>? comboKey,
	ComboMMopModel? initItem,
	Function(ComboMMopModel?)? onChangedCallback,
	required Function(ComboMMopModel?) onSaveCallback,
	Function(ComboMMopModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMMopModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMMopRepository().getComboMMop(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMMop,
			),
			compareFn: (item, sItem) => item.mmopId == sItem.mmopId,
			itemAsString: (item) {
				return item.mopName;
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

Widget itemBuilderComboMMop(
	BuildContext context, ComboMMopModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.mopName),
		),
	);
}
