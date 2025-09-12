import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';

class ReusableComboBox<T> extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String searchHintText;
  final GlobalKey<DropdownSearchState<T>>? comboKey;
  final T? initItem;
  final Function(T?)? onChangedCallback;
  final Function(T?) onSaveCallback;
  final String? Function(T?)? validatorCallback;

  // Data & Logic Properties
  final Future<List<T>> Function() dataLoader;
  final String Function(T) displayText;
  final bool Function(T, T) compareItems;
  final Widget Function(BuildContext, T, bool, bool)? customItemBuilder;

  // Styling Properties (optional)
  final Color? color; // override color utama (optional)
  final Color? backgroundColor; // override background (optional)
  final bool showClearButton;
  final bool disableFilter;
  final EdgeInsets? itemMargin;
  final bool isEnabled;
  final double? maxHeight;
  final IconData? prefixIcon;
  final bool showBorder;
  final double borderRadius;

  const ReusableComboBox({
    Key? key,
    required this.labelText,
    required this.searchHintText,
    required this.dataLoader,
    required this.displayText,
    required this.compareItems,
    required this.onSaveCallback,
    this.comboKey,
    this.initItem,
    this.onChangedCallback,
    this.validatorCallback,
    this.customItemBuilder,
    this.color,
    this.backgroundColor,
    this.showClearButton = true,
    this.disableFilter = false,
    this.itemMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.isEnabled = true,
    this.maxHeight = 300,
    this.prefixIcon,
    this.hintText,
    this.showBorder = true,
    this.borderRadius = 12.0,
  }) : super(key: key);

  Color get _mainColor => color ?? primaryColor;
  Color get _bkgColor => backgroundColor ?? pGrey;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: comboKey,
      enabled: isEnabled,
      selectedItem: initItem,
      // DECORATOR (semua warna dan border pakai constant)
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText ?? 'Pilih ${labelText.toLowerCase()}...',
          prefixIcon:
          prefixIcon != null ? Icon(prefixIcon, color: _mainColor) : null,
          suffixIcon: Icon(Icons.arrow_drop_down, color: _mainColor),
          filled: true,
          fillColor: _bkgColor,
          border:
          showBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: sGrey),
          )
              : InputBorder.none,
          enabledBorder:
          showBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: sGrey),
          )
              : InputBorder.none,
          focusedBorder:
          showBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: _mainColor, width: 2),
          )
              : InputBorder.none,
          errorBorder:
          showBorder
              ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: pRed),
          )
              : InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          labelStyle: bodyTextStyle(context, fontSize: 15),
          hintStyle: TextStyle(color: hintGrey, fontSize: 14),
        ),
      ),
      // DATA LOADER
      items: (filter, infiniteScrollProps) async {
        try {
          return await dataLoader();
        } catch (e) {
          return [];
        }
      },
      // CLEAR BUTTON
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          isVisible: showClearButton,
          icon: Icon(Icons.clear, size: 18, color: primaryLightColor),
        ),
      ),
      // DROPDOWN POPUP
      popupProps: PopupProps.menu(
        constraints: BoxConstraints(maxHeight: maxHeight ?? 300),
        disableFilter: disableFilter,
        showSelectedItems: true,
        showSearchBox: !disableFilter,
        itemBuilder: customItemBuilder ?? _defaultItemBuilder,
        // Container dropdown pakai constant color & shadow
        containerBuilder: (context, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: popupWidget,
          );
        },
        // Search field styling
        searchFieldProps: TextFieldProps(
          style: TextStyle(fontSize: 14),
          cursorColor: _mainColor,
          decoration: InputDecoration(
            hintText: searchHintText,
            hintStyle: TextStyle(color: hintGrey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: sGrey, size: 20),
            filled: true,
            fillColor: pGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(cardBorderRadius),
                topRight: Radius.circular(cardBorderRadius),
              ),
              borderSide: BorderSide(color: sGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(cardBorderRadius),
                topRight: Radius.circular(cardBorderRadius),
              ),
              borderSide: BorderSide(color: sGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(cardBorderRadius),
                topRight: Radius.circular(cardBorderRadius),
              ),
              borderSide: BorderSide(color: _mainColor),
            ),
          ),
        ),
        // Loading indicator
        loadingBuilder:
            (context, searchEntry) => Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_mainColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Memuat data...',
                style: TextStyle(color: sGrey, fontSize: 14),
              ),
            ],
          ),
        ),
        // Empty state
        emptyBuilder:
            (context, searchEntry) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, color: sGrey, size: 48),
              const SizedBox(height: 12),
              Text(
                'Tidak ada data ditemukan',
                style: TextStyle(color: sGrey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      compareFn: compareItems,
      itemAsString: displayText,
      onChanged: onChangedCallback,
      onSaved: onSaveCallback,
      validator: (value) {
        if (validatorCallback != null) {
          final result = validatorCallback!(value);
          if (result != null && result.isNotEmpty) return result;
        }
        return null;
      },
    );
  }

  // ITEM BUILDER default (pure constants)
  Widget _defaultItemBuilder(
      BuildContext context,
      T item,
      bool isSelected,
      bool isDisabled,
      ) {
    final mainColor = primaryColor ?? primaryColor;

    return Container(
      margin: itemMargin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
              isSelected ? mainColor.withOpacity(0.1) : Colors.transparent,
              border:
              isSelected
                  ? Border.all(color: mainColor.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                if (isSelected) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayText(item),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: mainColor, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}