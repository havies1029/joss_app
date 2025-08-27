import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/repositories/combobox/combombidang_repository.dart';

DropdownSearch<ComboMBidangModel> buildFieldComboMBidang({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMBidangModel>>? comboKey,
	ComboMBidangModel? initItem,
	Function(ComboMBidangModel?)? onChangedCallback,
	required Function(ComboMBidangModel?) onSaveCallback,
	Function(ComboMBidangModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMBidangModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMBidangRepository().getComboMBidang();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMBidang,
			),
			compareFn: (item, sItem) => item.mbidangId == sItem.mbidangId,
			itemAsString: (item) {
				return item.bidangNama;
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

Widget itemBuilderComboMBidang(
	BuildContext context, ComboMBidangModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.bidangNama),
		),
	);
}
