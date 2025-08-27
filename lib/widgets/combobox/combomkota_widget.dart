import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/repositories/combobox/combomkota_repository.dart';

DropdownSearch<ComboMKotaModel> buildFieldComboMKota({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMKotaModel>>? comboKey,
	ComboMKotaModel? initItem,  
  required String propinsiId,
	Function(ComboMKotaModel?)? onChangedCallback,
	required Function(ComboMKotaModel?) onSaveCallback,
	Function(ComboMKotaModel?)? validatorCallback, Key? key
	}) {
	return DropdownSearch<ComboMKotaModel>(
		key: comboKey,
		selectedItem: initItem,    
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMKotaRepository().getComboMKota(propinsiId);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMKota,
			),
			compareFn: (item, sItem) => item.mkotaId == sItem.mkotaId,
			itemAsString: (item) {
				return item.kotaDesc;
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

Widget itemBuilderComboMKota(
	BuildContext context, ComboMKotaModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kotaDesc),
		),
	);
}
