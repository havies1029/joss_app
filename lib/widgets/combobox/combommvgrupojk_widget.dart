import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';

// Revisi fungsi buildFieldComboMMvgrupOjk dengan desain custom
Widget buildFieldComboMMvgrupOjk(
    {required String labelText,
    GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>? comboKey,
    ComboMMvgrupOjkModel? initItem,
    Function(ComboMMvgrupOjkModel?)? onChangedCallback,
    required Function(ComboMMvgrupOjkModel?) onSaveCallback,
    Function(ComboMMvgrupOjkModel?)? validatorCallback}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label di atas field
      Text(
        labelText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),

      // DropdownSearch dengan custom decoration
      DropdownSearch<ComboMMvgrupOjkModel>(
        key: comboKey,
        selectedItem: initItem,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            hintText: '-- Pilih Jenis Kendaraan --',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan label text karena sudah ada di atas
            labelText: null,
          ),
        ),
        items: (filter, infiniteScrollProps) async {
          return ComboMMvgrupOjkRepository().getComboMMvgrupOjk(filter);
        },
        suffixProps: const DropdownSuffixProps(
          clearButtonProps: ClearButtonProps(isVisible: false),
          dropdownButtonProps: DropdownButtonProps(
            iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            iconOpened: Icon(Icons.keyboard_arrow_up, color: Color(0xFF91C050)),
          ),
        ),
        popupProps: PopupProps.modalBottomSheet(
          disableFilter: false,
          showSelectedItems: true,
          showSearchBox: false,
          itemBuilder: itemBuilderComboMMvgrupOjk,
          // Custom modal design
          modalBottomSheetProps: const ModalBottomSheetProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          containerBuilder: (context, popupWidget) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header modal
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih $labelText',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(child: popupWidget),
                ],
              ),
            );
          },
        ),
        compareFn: (item, sItem) => item.mmvgrupojkId == sItem.mmvgrupojkId,
        itemAsString: (item) {
          return item.grupNama;
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
              return "Field $labelText tidak boleh kosong";
            }
          }
          return null;
        },
      ),
    ],
  );
}

// Revisi item builder dengan design yang lebih menarik
Widget itemBuilderComboMMvgrupOjk(BuildContext context,
    ComboMMvgrupOjkModel item, bool isSelected, bool isDisabled) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? const Color(0xFF91C050) : Colors.grey[300]!,
        width: isSelected ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(8),
      color:
          isSelected ? const Color(0xFF91C050).withOpacity(0.1) : Colors.white,
    ),
    child: ListTile(
      selected: isSelected,
      title: Text(
        item.grupNama,
        style: TextStyle(
          color: isSelected ? const Color(0xFF91C050) : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: Color(0xFF91C050),
              size: 20,
            )
          : null,
    ),
  );
}
