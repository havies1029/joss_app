import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/repositories/combobox/combomjenisrugi_repository.dart';

DropdownSearch<ComboMJenisrugiModel> buildFieldComboMJenisrugi({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMJenisrugiModel>>? comboKey,
	ComboMJenisrugiModel? initItem,
	Function(ComboMJenisrugiModel?)? onChangedCallback,
	required Function(ComboMJenisrugiModel?) onSaveCallback,
	Function(ComboMJenisrugiModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMJenisrugiModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMJenisrugiRepository().getComboMJenisrugi();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMJenisrugi,
			),
			compareFn: (item, sItem) => item.mjenisrugiId == sItem.mjenisrugiId,
			itemAsString: (item) {
				return item.rugiDesc;
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

Widget itemBuilderComboMJenisrugi(
	BuildContext context, ComboMJenisrugiModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.rugiDesc),
		),
	);
}
