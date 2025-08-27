import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../models/combobox/combocoblist_model.dart';
import '../../repositories/combobox/combocoblist_repository.dart';

DropdownSearch<ComboCobListModel> buildFieldComboCobList({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboCobListModel>>? comboKey,
	ComboCobListModel? initItem,
	Function(ComboCobListModel?)? onChangedCallback,
	required Function(ComboCobListModel?) onSaveCallback,
	Function(ComboCobListModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboCobListModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: 'cob ...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboCobListRepository().getComboCobList();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboCobList,
			),
			compareFn: (item, sItem) => item.mCobApp1Id == sItem.mCobApp1Id,
			itemAsString: (item) {
				return item.cobNama;
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

Widget itemBuilderComboCobList(
	BuildContext context, ComboCobListModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.cobNama),
		),
	);
}
