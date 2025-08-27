import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/repositories/combobox/combombank_repository.dart';

DropdownSearch<ComboMBankModel> buildFieldComboMBank({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMBankModel>>? comboKey,
	ComboMBankModel? initItem,
	Function(ComboMBankModel?)? onChangedCallback,
	required Function(ComboMBankModel?) onSaveCallback,
	Function(ComboMBankModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMBankModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMBankRepository().getComboMBank();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: PopupProps.modalBottomSheet(
				showSearchBox: false,
				showSelectedItems: true,
				itemBuilder: itemBuilderComboMBank,
			),
		compareFn: (item, sItem) => item.mbankId == sItem.mbankId,
			itemAsString: (item) {
				return item.bankNama;
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

Widget itemBuilderComboMBank(
	BuildContext context, ComboMBankModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.bankNama),
		),
	);
}
