import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';
import 'package:joss_app/repositories/combobox/combomjnskel_repository.dart';

DropdownSearch<ComboMJnskelModel> buildFieldComboMJnskel({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnskelModel>>? comboKey,
	ComboMJnskelModel? initItem,
	Function(ComboMJnskelModel?)? onChangedCallback,
	required Function(ComboMJnskelModel?) onSaveCallback,
	Function(ComboMJnskelModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJnskelModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJnskelRepository().getComboMJnskel();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJnskel,
			),
			compareFn: (item, sItem) => item.mjnskelId == sItem.mjnskelId,
			itemAsString: (item) {
				return item.jenisDesc;
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

Widget itemBuilderComboMJnskel(
	BuildContext context, ComboMJnskelModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.jenisDesc),
		),
	);
}
