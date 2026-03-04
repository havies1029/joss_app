import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomtitle_model.dart';
import 'package:joss_app/repositories/combobox/combomtitle_repository.dart';

DropdownSearch<ComboMTitleModel> buildFieldComboMTitle({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMTitleModel>>? comboKey,
	ComboMTitleModel? initItem,
	Function(ComboMTitleModel?)? onChangedCallback,
	required Function(ComboMTitleModel?) onSaveCallback,
	Function(ComboMTitleModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMTitleModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMTitleRepository().getComboMTitle();
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMTitle,
			),
			compareFn: (item, sItem) => item.mtitleId == sItem.mtitleId,
			itemAsString: (item) {
				return item.titleDesc;
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

Widget itemBuilderComboMTitle(
	BuildContext context, ComboMTitleModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.titleDesc),
		),
	);
}
