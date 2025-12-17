  import 'package:flutter/material.dart';

  import '../../../../common/constants.dart';
  import '../../../../models/combobox/combocoblist_model.dart';
  import '../../../../repositories/combobox/combocoblist_repository.dart';
  import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
  import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';

  class AssetListWidget extends FormField<ComboMCobApp1Model?> {
    AssetListWidget({
      super.key,
      required String labelText,
      ComboMCobApp1Model? initItem,
      ValueChanged<ComboMCobApp1Model?>? onChangedCallback,
      required ValueChanged<ComboMCobApp1Model?> onSaveCallback,
      String? Function(ComboMCobApp1Model?)? validatorCallback,
      Future<List<ComboMCobApp1Model>> Function()? loader,
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

        // Data Loader
        if (loader == null) {
          return Text(
            'Loader tidak disediakan',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
          );
        }

        return FutureBuilder<List<ComboMCobApp1Model>>(
          future: loader(),   // 🔥 Hapus fallback ke repository
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

            final items = snapshot.data ?? const <ComboMCobApp1Model>[];
            if (items.isEmpty) {
              return Text(
                'Data COB kosong',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              );
            }

            // Sort data (optional)
            items.sort((a, b) => b.cobNama.compareTo(a.cobNama));

            // Build Chip List
            final chips = items.map((item) {
              final bool selected = field.value?.mCobApp1Id == item.mCobApp1Id;

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
                    ComboMCobApp1Model? next;

                    if (isNowSelected) {
                      next = item;
                    } else if (allowDeselect) {
                      next = null;
                    } else {
                      return;
                    }

                    field.didChange(next);
                    onChangedCallback?.call(next);
                  },
                ),
              );
            }).toList();

            return horizontalScroll
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            )
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips,
            );
          },
        );
      },
    );
  }
