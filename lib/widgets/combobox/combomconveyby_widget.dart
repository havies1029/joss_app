import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomconveyby_model.dart';
import 'package:joss_app/repositories/combobox/combomconveyby_repository.dart';

DropdownSearch<ComboMConveybyModel> buildFieldComboMConveyby({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMConveybyModel>>? comboKey,
	ComboMConveybyModel? initItem,
  required String mopId,
	Function(ComboMConveybyModel?)? onChangedCallback,
	required Function(ComboMConveybyModel?) onSaveCallback,
	Function(ComboMConveybyModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMConveybyModel>(
		key: comboKey,    
		selectedItem: initItem,    
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMConveybyRepository().getComboMConveyby(mopId);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMConveyby,
			),
			compareFn: (item, sItem) => item.mconveybyId == sItem.mconveybyId,
			itemAsString: (item) {
				return item.conveybyNama;
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

Widget itemBuilderComboMConveyby(
	BuildContext context, ComboMConveybyModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.conveybyNama),
		),
	);
}
