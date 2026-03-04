import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combosppapolis_model.dart';
import 'package:joss_app/repositories/combobox/combosppapolis_repository.dart';

DropdownSearch<ComboSppaPolisModel> buildFieldComboSppaPolis({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboSppaPolisModel>>? comboKey,
	ComboSppaPolisModel? initItem,
	Function(ComboSppaPolisModel?)? onChangedCallback,
	required Function(ComboSppaPolisModel?) onSaveCallback,
	Function(ComboSppaPolisModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboSppaPolisModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboSppaPolisRepository().getComboSppaPolis(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: true,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboSppaPolis,
			),
			compareFn: (item, sItem) => item.sppaId == sItem.sppaId,
			itemAsString: (item) {
				return item.polisNo;
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

Widget itemBuilderComboSppaPolis(
	BuildContext context, ComboSppaPolisModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.polisNo),
		),
	);
}
