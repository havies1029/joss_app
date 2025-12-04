import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomkelurahan_model.dart';
import 'package:joss_app/repositories/combobox/combomkelurahan_repository.dart';

DropdownSearch<ComboMKelurahanModel> buildFieldComboMKelurahan({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMKelurahanModel>>? comboKey,
	ComboMKelurahanModel? initItem,
  required String kecamatanId,
	Function(ComboMKelurahanModel?)? onChangedCallback,
	required Function(ComboMKelurahanModel?) onSaveCallback,
	Function(ComboMKelurahanModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMKelurahanModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMKelurahanRepository().getComboMKelurahan(kecamatanId);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMKelurahan,
			),
			compareFn: (item, sItem) => item.mkelurahanId == sItem.mkelurahanId,
			itemAsString: (item) {
				return item.kelurahanNama;
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

Widget itemBuilderComboMKelurahan(
	BuildContext context, ComboMKelurahanModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.kelurahanNama),
		),
	);
}
