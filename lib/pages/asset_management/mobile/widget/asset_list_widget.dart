import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../models/combobox/combocoblist_model.dart';
import '../../../../repositories/combobox/combocoblist_repository.dart';

class AssetListWidget extends FormField<ComboCobListModel?> {
  AssetListWidget({
    super.key,
    required String labelText,
    ComboCobListModel? initItem,
    ValueChanged<ComboCobListModel?>? onChangedCallback,
    required ValueChanged<ComboCobListModel?> onSaveCallback,
    String? Function(ComboCobListModel?)? validatorCallback,
    Future<List<ComboCobListModel>> Function()? loader,
    bool horizontalScroll = true,
    bool allowDeselect = false,
  }) : super(
    initialValue: initItem,
    validator: validatorCallback,
    onSaved: onSaveCallback,
    builder: (field) {
      final theme = Theme.of(field.context);
      final textStyle = headingStyle(field.context, fontSize: 14);
      final Color chipBg = pGrey;
      final Color chipSelected = primaryColor;
      final double radius = cardBorderRadius;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (labelText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                labelText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primaryLightColor,
                ),
              ),
            ),

          // Data Loader
          FutureBuilder<List<ComboCobListModel>>(
            future: loader != null
                ? loader()
                : ComboCobListRepository().getComboCobList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 44,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  'Gagal memuat COB',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
                );
              }

              final items = snapshot.data ?? const <ComboCobListModel>[];
              if (items.isEmpty) {
                return Text(
                  'Data COB kosong',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                );
              }

              // 🔥 Sort descending berdasarkan nama COB
              items.sort((a, b) => b.cobNama.compareTo(a.cobNama));

              // items.sort((a, b) => b.mCobApp1Id.compareTo(a.mCobApp1Id));

              Widget chipList;

              // Builder chip
              List<Widget> chips = items.map((item) {
                final bool selected =
                    field.value?.mCobApp1Id == item.mCobApp1Id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item.cobNama, style: textStyle),
                    selected: selected,
                    selectedColor: chipSelected,
                    backgroundColor: chipBg,
                    showCheckmark: false,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    onSelected: (isNowSelected) {
                      ComboCobListModel? next;
                      // if (isNowSelected) {
                      //   next = item;
                      // } else {
                      //   next = allowDeselect ? null : item;
                      // }
                      if (isNowSelected) {
                        next = item;
                      } else if (allowDeselect) {
                        next = null;
                      }else {
                        return; // igno
                      }
                      field.didChange(next);
                      onChangedCallback?.call(next);
                    },
                  ),
                );
              }).toList();

              if (horizontalScroll) {
                chipList = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: chips),
                );
              } else {
                chipList = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips,
                );
              }

              return chipList;
            },
          ),

          // Error text (validator)
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                field.errorText!,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
            ),
        ],
      );
    },
  );
}
