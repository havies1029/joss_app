import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjnsclient_model.dart';
import 'package:joss_app/repositories/combobox/combomjnsclient_repository.dart';

DropdownSearch<ComboMJnsclientModel> buildFieldComboMJnsclient({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnsclientModel>>? comboKey,
	ComboMJnsclientModel? initItem,
	Function(ComboMJnsclientModel?)? onChangedCallback,
	required Function(ComboMJnsclientModel?) onSaveCallback,
	Function(ComboMJnsclientModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJnsclientModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJnsclientRepository().getComboMJnsclient();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJnsclient,
			),
			compareFn: (item, sItem) => item.mjnsclientId == sItem.mjnsclientId,
			itemAsString: (item) {
				return item.jenisNama;
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

Widget itemBuilderComboMJnsclient(
	BuildContext context, ComboMJnsclientModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.jenisNama),
		),
	);
}
