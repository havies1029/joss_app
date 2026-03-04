import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomzonabanjir_model.dart';
import 'package:joss_app/repositories/combobox/combomzonabanjir_repository.dart';

DropdownSearch<ComboMZonaBanjirModel> buildFieldComboMZonaBanjir({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMZonaBanjirModel>>? comboKey,
	ComboMZonaBanjirModel? initItem,
	Function(ComboMZonaBanjirModel?)? onChangedCallback,
	required Function(ComboMZonaBanjirModel?) onSaveCallback,
	Function(ComboMZonaBanjirModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMZonaBanjirModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMZonaBanjirRepository().getComboMZonaBanjir();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMZonaBanjir,
			),
			compareFn: (item, sItem) => item.mzonabanjirId == sItem.mzonabanjirId,
			itemAsString: (item) {
				return item.zonaNama;
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

Widget itemBuilderComboMZonaBanjir(
	BuildContext context, ComboMZonaBanjirModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.zonaNama),
		),
	);
}
