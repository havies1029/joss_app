import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
import 'package:joss_app/repositories/combobox/combommvpakai_repository.dart';

DropdownSearch<ComboMMvpakaiModel> buildFieldComboMMvpakai({
  required String labelText,
  GlobalKey<DropdownSearchState<ComboMMvpakaiModel>>? comboKey,
  ComboMMvpakaiModel? initItem,
  Function(ComboMMvpakaiModel?)? onChangedCallback,
  required Function(ComboMMvpakaiModel?) onSaveCallback,
  Function(ComboMMvpakaiModel?)? validatorCallback
}) {
  return DropdownSearch<ComboMMvpakaiModel>(
    key: comboKey,
    selectedItem: initItem,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: 'penggunaan ...',
        labelText: labelText,
      ),
    ),
    items: (filter, infiniteScrollProps) async {
      return ComboMMvpakaiRepository().getComboMMvpakai(filter);
    },
    suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
    popupProps: const PopupPropsMultiSelection.modalBottomSheet(
      disableFilter: true,
      showSelectedItems: true,
      showSearchBox: true,
      itemBuilder: itemBuilderComboMMvpakai,
    ),
    compareFn: (item, sItem) => item.mmvpakaiId == sItem.mmvpakaiId,
    itemAsString: (item) {
      return item.pakaiNama;
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

Widget itemBuilderComboMMvpakai(
    BuildContext context, ComboMMvpakaiModel item, bool isSelected, bool isDisabled) {
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
      title: Text(item.pakaiNama),
    ),
  );
}
