import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjenisrugimv_model.dart';
import 'package:joss_app/repositories/combobox/combomjenisrugimv_repository.dart';

DropdownSearch<ComboMJenisrugimvModel> buildFieldComboMJenisrugimv({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJenisrugimvModel>>? comboKey,
	ComboMJenisrugimvModel? initItem,
	Function(ComboMJenisrugimvModel?)? onChangedCallback,
	required Function(ComboMJenisrugimvModel?) onSaveCallback,
	Function(ComboMJenisrugimvModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJenisrugimvModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: 'penyebab kerugian',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJenisrugimvRepository().getComboMJenisrugimv();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJenisrugimv,
			),
			compareFn: (item, sItem) => item.mjenisrugimvId == sItem.mjenisrugimvId,
			itemAsString: (item) {
				return item.jenisrugiNama;
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

Widget itemBuilderComboMJenisrugimv(
	BuildContext context, ComboMJenisrugimvModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.jenisrugiNama),
		),
	);
}
