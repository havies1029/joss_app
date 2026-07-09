import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combomreferral_model.dart';
import 'package:joss_app/repositories/combobox/combomreferral_repository.dart';

DropdownSearch<ComboMReferralModel> buildFieldComboMReferral({
  required String labelText,
  GlobalKey<DropdownSearchState<ComboMReferralModel>>? comboKey,
  ComboMReferralModel? initItem,
  Function(ComboMReferralModel?)? onChangedCallback,
  required Function(ComboMReferralModel?) onSaveCallback,
  Function(ComboMReferralModel?)? validatorCallback,
}) {
  return DropdownSearch<ComboMReferralModel>(
    key: comboKey,
    selectedItem: initItem,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: '...',
        labelText: labelText,
      ),
    ),
    items: (filter, infiniteScrollProps) async {
      return ComboMReferralRepository().getComboMReferral(filter);
    },
    suffixProps: const DropdownSuffixProps(
      clearButtonProps: ClearButtonProps(isVisible: false),
    ),
    popupProps: const PopupPropsMultiSelection.modalBottomSheet(
      disableFilter: true,
      showSelectedItems: true,
      showSearchBox: true,
      itemBuilder: itemBuilderComboMReferral,
    ),
    compareFn: (item, sItem) => item.mreferralId == sItem.mreferralId,
    itemAsString: (item) {
      return "${item.kodeUnik} - ${item.namaMarketing}";
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

Widget itemBuilderComboMReferral(
  BuildContext context,
  ComboMReferralModel item,
  bool isSelected,
  bool isDisabled,
) {
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
      title: Text("${item.kodeUnik} - ${item.namaMarketing}"),
    ),
  );
}
