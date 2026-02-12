import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combominsurance_model.dart';
import 'package:joss_app/repositories/combobox/combominsurance_repository.dart';

DropdownSearch<ComboMInsuranceModel> buildFieldComboMInsurance({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMInsuranceModel>>? comboKey,
	ComboMInsuranceModel? initItem,
	Function(ComboMInsuranceModel?)? onChangedCallback,
	required Function(ComboMInsuranceModel?) onSaveCallback,
	Function(ComboMInsuranceModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMInsuranceModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMInsuranceRepository().getComboMInsurance(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMInsurance,
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

Widget itemBuilderComboMInsurance(
	BuildContext context, ComboMInsuranceModel item, bool isSelected, bool isDisabled) {
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
