import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';
import 'package:joss_app/repositories/combobox/combommvmodel_repository.dart';

DropdownSearch<ComboMMvmodelModel> buildFieldComboMMvmodel({
  required String labelText,
  GlobalKey<DropdownSearchState<ComboMMvmodelModel>>? comboKey,
  ComboMMvmodelModel? initItem,
  required String mvtipeId,
  Function(ComboMMvmodelModel?)? onChangedCallback,
  required Function(ComboMMvmodelModel?) onSaveCallback,
  Function(ComboMMvmodelModel?)? validatorCallback
}) {
  return DropdownSearch<ComboMMvmodelModel>(
    key: comboKey,
    selectedItem: initItem,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: 'model ...',
        labelText: labelText,
      ),
    ),
    items: (filter, infiniteScrollProps) async {
      return ComboMMvmodelRepository().getComboMMvmodel(mvtipeId, filter);
    },
    suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
    popupProps: const PopupPropsMultiSelection.modalBottomSheet(
      disableFilter: true,
      showSelectedItems: true,
      showSearchBox: true,
      itemBuilder: itemBuilderComboMMvmodel,
    ),
    compareFn: (item, sItem) => item.mmvmodelId == sItem.mmvmodelId,
    itemAsString: (item) {
      return item.mmvtipeId;
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

Widget itemBuilderComboMMvmodel(
    BuildContext context, ComboMMvmodelModel item, bool isSelected, bool isDisabled) {
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
      title: Text(item.mmvtipeId),
    ),
  );
}
