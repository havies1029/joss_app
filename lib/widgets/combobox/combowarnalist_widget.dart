import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combowarnalist_model.dart';
import 'package:joss_app/repositories/combobox/combowarnalist_repository.dart';

DropdownSearch<ComboWarnaListModel> buildFieldComboWarnaList({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboWarnaListModel>>? comboKey,
	ComboWarnaListModel? initItem,
	Function(ComboWarnaListModel?)? onChangedCallback,
	required Function(ComboWarnaListModel?) onSaveCallback,
	Function(ComboWarnaListModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboWarnaListModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: 'warna ...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboWarnaListRepository().getComboWarnaList(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboWarnaList,
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

Widget itemBuilderComboWarnaList(
	BuildContext context, ComboWarnaListModel item, bool isSelected, bool isDisabled) {
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
