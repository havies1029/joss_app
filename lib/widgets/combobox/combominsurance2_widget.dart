import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combominsurance2_model.dart';
import 'package:joss_app/repositories/combobox/combominsurance2_repository.dart';

DropdownSearch<ComboMInsurance2Model> buildFieldComboMInsurance2({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMInsurance2Model>>? comboKey,
	ComboMInsurance2Model? initItem,
	Function(ComboMInsurance2Model?)? onChangedCallback,
	required Function(ComboMInsurance2Model?) onSaveCallback,
	Function(ComboMInsurance2Model?)? validatorCallback
	}) {
	return DropdownSearch<ComboMInsurance2Model>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMInsurance2Repository().getComboMInsurance2(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMInsurance2,
			),
			compareFn: (item, sItem) => item.minsuranceId == sItem.minsuranceId,
			itemAsString: (item) {
				return item.insuranceName;
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

Widget itemBuilderComboMInsurance2(
	BuildContext context, ComboMInsurance2Model item, bool isSelected, bool isDisabled) {
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
			title: Text(item.insuranceName),
		),
	);
}
