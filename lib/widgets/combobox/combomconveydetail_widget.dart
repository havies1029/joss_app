import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomconveydetail_model.dart';
import 'package:joss_app/repositories/combobox/combomconveydetail_repository.dart';

DropdownSearch<ComboMConveyDetailModel> buildFieldComboMConveyDetail({
	required String labelText,
	GlobalKey<DropdownSearchState<ComboMConveyDetailModel>>? comboKey,
	ComboMConveyDetailModel? initItem,
  required String mopId,
  required String conveyById,
	Function(ComboMConveyDetailModel?)? onChangedCallback,
	required Function(ComboMConveyDetailModel?) onSaveCallback,
	Function(ComboMConveyDetailModel?)? validatorCallback
	}) {
	return DropdownSearch<ComboMConveyDetailModel>(
		key: comboKey,
		selectedItem: initItem,
		decoratorProps: DropDownDecoratorProps(
			decoration: InputDecoration(
				hintText: '...',
				labelText: labelText,
			),
		),
			items: (filter, infiniteScrollProps) async {
				return ComboMConveyDetailRepository().getComboMConveyDetail(mopId, conveyById);
			},
			suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
			popupProps: const PopupPropsMultiSelection.modalBottomSheet(
				disableFilter: false,
				showSelectedItems: true,
				showSearchBox: false,
				itemBuilder: itemBuilderComboMConveyDetail,
			),
			compareFn: (item, sItem) => item.mconveydetailId == sItem.mconveydetailId,
			itemAsString: (item) {
				return item.detailDesc;
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

Widget itemBuilderComboMConveyDetail(
	BuildContext context, ComboMConveyDetailModel item, bool isSelected, bool isDisabled) {
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
			title: Text(item.detailDesc),
		),
	);
}
