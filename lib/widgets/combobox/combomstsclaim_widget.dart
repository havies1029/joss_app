import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/repositories/combobox/combomstsclaim_repository.dart';

DropdownSearch<ComboMStsclaimModel> buildFieldComboMStsclaim({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMStsclaimModel>>? comboKey,
	ComboMStsclaimModel? initItem,
	Function(ComboMStsclaimModel?)? onChangedCallback,
	required Function(ComboMStsclaimModel?) onSaveCallback,
	Function(ComboMStsclaimModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMStsclaimModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMStsclaimRepository().getComboMStsclaim();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMStsclaim,
			),
			compareFn: (item, sItem) => item.mstsclaimId == sItem.mstsclaimId,
			itemAsString: (item) {
				return item.statusNama;
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

Widget itemBuilderComboMStsclaim(
	BuildContext context, ComboMStsclaimModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.statusNama),
		),
	);
}
