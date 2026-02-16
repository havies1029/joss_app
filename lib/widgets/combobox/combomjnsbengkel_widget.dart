import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/repositories/combobox/combomjnsbengkel_repository.dart';

DropdownSearch<ComboMJnsbengkelModel> buildFieldComboMJnsbengkel({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJnsbengkelModel>>? comboKey,
	ComboMJnsbengkelModel? initItem,
	Function(ComboMJnsbengkelModel?)? onChangedCallback,
	required Function(ComboMJnsbengkelModel?) onSaveCallback,
	Function(ComboMJnsbengkelModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJnsbengkelModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJnsbengkelRepository().getComboMJnsbengkel();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJnsbengkel,
			),
			compareFn: (item, sItem) => item.mjnsbengkelId == sItem.mjnsbengkelId,
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

Widget itemBuilderComboMJnsbengkel(
	BuildContext context, ComboMJnsbengkelModel item, bool isSelected, bool isDisabled) {
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
