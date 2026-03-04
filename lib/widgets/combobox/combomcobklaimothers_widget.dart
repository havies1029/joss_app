import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomcobklaimothers_model.dart';
import 'package:joss_app/repositories/combobox/combomcobklaimothers_repository.dart';

DropdownSearch<ComboMCobKlaimOthersModel> buildFieldComboMCobKlaimOthers({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMCobKlaimOthersModel>>? comboKey,
	ComboMCobKlaimOthersModel? initItem,
	Function(ComboMCobKlaimOthersModel?)? onChangedCallback,
	required Function(ComboMCobKlaimOthersModel?) onSaveCallback,
	Function(ComboMCobKlaimOthersModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMCobKlaimOthersModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMCobKlaimOthersRepository().getComboMCobKlaimOthers(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboMCobKlaimOthers,
			),
			compareFn: (item, sItem) => item.mcobId == sItem.mcobId,
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

Widget itemBuilderComboMCobKlaimOthers(
	BuildContext context, ComboMCobKlaimOthersModel item, bool isSelected, bool isDisabled) {
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
