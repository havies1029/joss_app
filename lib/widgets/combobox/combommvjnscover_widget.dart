import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';

DropdownSearch<ComboMMvjnscoverModel> buildFieldComboMMvjnscover({
	required String labelText,
	required bool enabled,
	GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>? comboKey,
	ComboMMvjnscoverModel? initItem,
	Function(ComboMMvjnscoverModel?)? onChangedCallback,
	required Function(ComboMMvjnscoverModel?) onSaveCallback,
	Function(ComboMMvjnscoverModel?)? validatorCallback
}) {
	return DropdownSearch<ComboMMvjnscoverModel>(
		key: comboKey,
		enabled: enabled,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
		items: (filter, infiniteScrollProps) async {
			return ComboMMvjnscoverRepository().getComboMMvjnscover();
		},
		suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
		popupProps: const PopupPropsMultiSelection.modalBottomSheet(
			disableFilter: false,
			showSelectedItems: true,
			showSearchBox: false,
			itemBuilder: itemBuilderComboMMvjnscover,
		),
		compareFn: (item, sItem) => item.mmvjnscoverId == sItem.mmvjnscoverId,
		itemAsString: (item) {
			return item.coverName;
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

Widget itemBuilderComboMMvjnscover(
		BuildContext context, ComboMMvjnscoverModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.coverName),
		),
	);
}
