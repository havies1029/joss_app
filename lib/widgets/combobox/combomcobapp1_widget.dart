import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';

DropdownSearch<ComboMCobApp1Model> buildFieldComboMCobApp1({
  required String labelText,
  GlobalKey<DropdownSearchState<ComboMCobApp1Model>>? comboKey,
  ComboMCobApp1Model? initItem,
  Function(ComboMCobApp1Model?)? onChangedCallback,
  required Function(ComboMCobApp1Model?) onSaveCallback,
  Function(ComboMCobApp1Model?)? validatorCallback
}) {
  return DropdownSearch<ComboMCobApp1Model>(
    key: comboKey,
    selectedItem: initItem,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: 'COB ...',
        labelText: labelText,
      ),
    ),
    items: (filter, infiniteScrollProps) async {
      return ComboMCobApp1Repository().getComboMCobApp1(filter);
    },
    suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
    popupProps: const PopupPropsMultiSelection.modalBottomSheet(
      disableFilter: true,
      showSelectedItems: true,
      showSearchBox: true,
      itemBuilder: itemBuilderComboMCobApp1,
    ),
    compareFn: (item, sItem) => item.mCobApp1Id == sItem.mCobApp1Id,
    itemAsString: (item) {
      return item.cobNama;
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

Widget itemBuilderComboMCobApp1(
    BuildContext context, ComboMCobApp1Model item, bool isSelected, bool isDisabled) {
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
      title: Text(item.cobNama),
    ),
  );
}
