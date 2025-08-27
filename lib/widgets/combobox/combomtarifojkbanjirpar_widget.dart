import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';
import 'package:joss_app/repositories/combobox/combomtarifojkbanjirpar_repository.dart';

DropdownSearch<ComboMTarifojkBanjirParModel> buildFieldComboMTarifojkBanjirPar({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMTarifojkBanjirParModel>>? comboKey,
	ComboMTarifojkBanjirParModel? initItem,
	Function(ComboMTarifojkBanjirParModel?)? onChangedCallback,
	required Function(ComboMTarifojkBanjirParModel?) onSaveCallback,
	Function(ComboMTarifojkBanjirParModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMTarifojkBanjirParModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMTarifojkBanjirParRepository().getComboMTarifojkBanjirPar();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMTarifojkBanjirPar,
			),
			compareFn: (item, sItem) => item.mtarifojkbanjirparId == sItem.mtarifojkbanjirparId,
			itemAsString: (item) {
				return item.kriteria;
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

Widget itemBuilderComboMTarifojkBanjirPar(
	BuildContext context, ComboMTarifojkBanjirParModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kriteria),
		),
	);
}
