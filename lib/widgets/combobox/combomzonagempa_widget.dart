import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomzonagempa_model.dart';
import 'package:joss_app/repositories/combobox/combomzonagempa_repository.dart';

DropdownSearch<ComboMZonaGempaModel> buildFieldComboMZonaGempa({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMZonaGempaModel>>? comboKey,
	ComboMZonaGempaModel? initItem,
	Function(ComboMZonaGempaModel?)? onChangedCallback,
	required Function(ComboMZonaGempaModel?) onSaveCallback,
	Function(ComboMZonaGempaModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMZonaGempaModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMZonaGempaRepository().getComboMZonaGempa();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: true)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMZonaGempa,
			),
			compareFn: (item, sItem) => item.mzonagempaId == sItem.mzonagempaId,
			itemAsString: (item) {
				return item.zonaNama;
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

Widget itemBuilderComboMZonaGempa(
	BuildContext context, ComboMZonaGempaModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.zonaNama),
		),
	);
}
