import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/repositories/combobox/combomkabzonagempa_repository.dart';

DropdownSearch<ComboMKabZonaGempaModel> buildFieldComboMKabZonaGempa({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>? comboKey,
	ComboMKabZonaGempaModel? initItem,
	Function(ComboMKabZonaGempaModel?)? onChangedCallback,
	required Function(ComboMKabZonaGempaModel?) onSaveCallback,
	Function(ComboMKabZonaGempaModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMKabZonaGempaModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMKabZonaGempaRepository().getComboMKabZonaGempa(filter, "");
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: true)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMKabZonaGempa,
			),
			compareFn: (item, sItem) => item.mkabzonagempaId == sItem.mkabzonagempaId,
			itemAsString: (item) {
				//return item.kabupaten;
				return '${item.mzonagempaId} - ${item.kabupaten}';
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

Widget itemBuilderComboMKabZonaGempa(
	BuildContext context, ComboMKabZonaGempaModel item, bool isSelected, bool isDisabled) {
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
			title: Text('${item.mzonagempaId} - ${item.kabupaten}'),
		),
	);
}
