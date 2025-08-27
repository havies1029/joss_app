import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';

DropdownSearch<ComboMJabatanModel> buildFieldComboMJabatan({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJabatanModel>>? comboKey,
	ComboMJabatanModel? initItem,
	Function(ComboMJabatanModel?)? onChangedCallback,
	required Function(ComboMJabatanModel?) onSaveCallback,
	Function(ComboMJabatanModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJabatanModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJabatanRepository().getComboMJabatan();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJabatan,
			),
			compareFn: (item, sItem) => item.mjabatanId == sItem.mjabatanId,
			itemAsString: (item) {
				return item.jabatanDesc;
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

Widget itemBuilderComboMJabatan(
	BuildContext context, ComboMJabatanModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.jabatanDesc),
		),
	);
}
