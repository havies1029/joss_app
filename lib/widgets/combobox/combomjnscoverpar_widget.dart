import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/repositories/combobox/combomjnscoverpar_repository.dart';

DropdownSearch<ComboMJnscoverParModel> buildFieldComboMJnscoverPar({
  required String labelText,
  GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>? comboKey,
  ComboMJnscoverParModel? initItem,
  Function(ComboMJnscoverParModel?)? onChangedCallback,
  required Function(ComboMJnscoverParModel?) onSaveCallback,
  Function(ComboMJnscoverParModel?)? validatorCallback
}) {
  return DropdownSearch<ComboMJnscoverParModel>(
    key: comboKey,
    selectedItem: initItem,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: 'Jenis Cover ...',
        labelText: labelText,
      ),
    ),
    items: (filter, infiniteScrollProps) async {
      return ComboMJnscoverParRepository().getComboMJnscoverPar();
    },
    suffixProps: const DropdownSuffixProps(clearButtonProps: ClearButtonProps(isVisible: false)),
    popupProps: const PopupPropsMultiSelection.modalBottomSheet(
      disableFilter: false,
      showSelectedItems: true,
      showSearchBox: false,
      itemBuilder: itemBuilderComboMJnscoverPar,
    ),
    compareFn: (item, sItem) => item.mjnscoverparId == sItem.mjnscoverparId,
    itemAsString: (item) {
      return item.jenisNama;
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

Widget itemBuilderComboMJnscoverPar(
    BuildContext context, ComboMJnscoverParModel item, bool isSelected, bool isDisabled) {
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
      title: Text(item.jenisNama),
    ),
  );
}
