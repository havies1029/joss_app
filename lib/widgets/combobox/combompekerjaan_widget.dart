import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/repositories/combobox/combompekerjaan_repository.dart';

DropdownSearch<ComboMPekerjaanModel> buildFieldComboMPekerjaan({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMPekerjaanModel>>? comboKey,
	ComboMPekerjaanModel? initItem,
	Function(ComboMPekerjaanModel?)? onChangedCallback,
	required Function(ComboMPekerjaanModel?) onSaveCallback,
	Function(ComboMPekerjaanModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMPekerjaanModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMPekerjaanRepository().getComboMPekerjaan();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMPekerjaan,
			),
			compareFn: (item, sItem) => item.mpekerjaanId == sItem.mpekerjaanId,
			itemAsString: (item) {
				return item.kerjaNama;
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

Widget itemBuilderComboMPekerjaan(
	BuildContext context, ComboMPekerjaanModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kerjaNama),
		),
	);
}
