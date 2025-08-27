import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/repositories/combobox/comborokupasi_repository.dart';

DropdownSearch<ComboROkupasiModel> buildFieldComboROkupasi({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboROkupasiModel>>? comboKey,
	ComboROkupasiModel? initItem,
	Function(ComboROkupasiModel?)? onChangedCallback,
	required Function(ComboROkupasiModel?) onSaveCallback,
	Function(ComboROkupasiModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboROkupasiModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboROkupasiRepository().getComboROkupasi(filter);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: true,
				itemBuilder: itemBuilderComboROkupasi,
			),
			compareFn: (item, sItem) => item.rokupasiId == sItem.rokupasiId,
			itemAsString: (item) {
				return '${item.kodeOjk} - ${item.okupasiDesc}';
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

Widget itemBuilderComboROkupasi(
	BuildContext context, ComboROkupasiModel item, bool isSelected, bool isDisabled) {
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
			title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
          Text(item.kodeOjk),
			    Text(item.okupasiDesc),
			  ],
			),
		),
	);
}
