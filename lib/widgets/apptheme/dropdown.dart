part of '../../common/constants.dart';

class ReusableComboBox<T> extends StatelessWidget {
  final String hintText;
  final String? searchHintText;
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

  // Simplified Styling (fixed, not customizable)
  final bool showClearButton;
  final bool enableSearch;
  final bool isEnabled;
  final double maxHeight;
  final IconData? prefixIcon;

  // Internal cache untuk menyimpan data items
  List<T>? _cachedItems;

  ReusableComboBox({
    Key? key,
    required this.hintText,
    required this.dataLoader,
    required this.displayText,
    required this.compareItems,
    required this.onSaveCallback,
    this.searchHintText,
    this.comboKey,
    this.initItem,
    this.onChangedCallback,
    this.validatorCallback,
    this.customItemBuilder,
    this.showClearButton = true,
    this.enableSearch = true,
    this.isEnabled = true,
    this.maxHeight = 300,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: comboKey,
      enabled: isEnabled,
      selectedItem: initItem,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: bodyTextStyle(context),
          prefixIcon:
              prefixIcon != null ? Icon(prefixIcon, color: primaryColor) : null,
          filled: true,
          fillColor: formGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: sGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: sGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
      // DATA LOADER
      items: (filter, infiniteScrollProps) async {
        try {
          final items = await dataLoader();
          _cachedItems = items;
          return items;
        } catch (_) {
          _cachedItems = [];
          return [];
        }
      },
      // CLEAR & DROPDOWN BUTTON
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          isVisible: showClearButton,
          icon: Icon(Icons.clear, size: 16, color: primaryLightColor),
        ),
        dropdownButtonProps: DropdownButtonProps(
          iconOpened: SvgPicture.asset("assets/icons/arrow_up.svg", width: 16),
          iconClosed: SvgPicture.asset(
            "assets/icons/arrow_down.svg",
            width: 16,
          ),
          isVisible: true,
        ),
      ),
      // DROPDOWN POPUP
      popupProps: PopupProps.menu(
        menuProps: MenuProps(
          margin: EdgeInsets.only(top: 5),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        constraints: BoxConstraints(maxHeight: maxHeight),
        showSelectedItems: true,
        showSearchBox: enableSearch,
        itemBuilder: customItemBuilder ?? _defaultItemBuilderWithDivider,
        containerBuilder: (context, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              color: formGrey,
              border: Border.all(color: sGrey),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(cardBorderRadius),
              ),
            ),
            child: popupWidget,
          );
        },
        searchFieldProps:
            enableSearch
                ? TextFieldProps(
                  style: inputTextStyle(context, color: hintGrey),
                  cursorColor: primaryLightColor,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: searchHintText ?? "Cari...",
                    hintStyle: inputTextStyle(context, color: hintGrey),
                    prefixIcon: Icon(Icons.search, color: hintGrey, size: 18),
                    filled: true,
                    fillColor: formGrey,
                    border: InputBorder.none,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 20,
                    ),
                  ),
                )
                : const TextFieldProps(
                  decoration: InputDecoration(border: InputBorder.none),
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

  Widget _defaultItemBuilderWithDivider(
    BuildContext context,
    T item,
    bool isSelected,
    bool isDisabled,
  ) {
    // Cek apakah ini item pertama atau terakhir
    final items = _cachedItems ?? [];
    final isFirstItem = items.isNotEmpty && compareItems(item, items.first);
    final isLastItem = items.isNotEmpty && compareItems(item, items.last);

    return Column(
      children: [
        // Divider di atas hanya untuk item pertama
        if (isFirstItem) kDivider(color: sGrey),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(displayText(item), style: bodyTextStyle(context)),
          ),
        ),

        // Divider di bawah untuk semua item kecuali yang terakhir
        if (!isLastItem) kDivider(color: sGrey),
      ],
    );
  }

  // Tetap sediakan method lama untuk backward compatibility
  Widget defaultItemBuilder(
    BuildContext context,
    T item,
    bool isSelected,
    bool isDisabled,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(displayText(item), style: bodyTextStyle(context)),
          ),
        ),
        kDivider(color: sGrey),
      ],
    );
  }
}
