part of '../../common/constants.dart';

class ReusableComboBox<T> extends StatefulWidget {
  final String hintText;
  final GlobalKey<DropdownSearchState<T>>? comboKey;
  final T? initItem;
  final Function(T?)? onChangedCallback;
  final Function(T?) onSaveCallback;
  final String? Function(T?)? validatorCallback;

  final Future<List<T>> Function() dataLoader;
  final String Function(T) displayText;
  final bool Function(T, T) compareItems;
  final Widget Function(BuildContext, T, bool, bool)? customItemBuilder;

  final bool showClearButton;
  final bool enableSearch;
  final bool isEnabled;
  final double maxHeight;
  final IconData? prefixIcon;
  final String? errorText;

  ReusableComboBox({
    Key? key,
    required this.hintText,
    required this.dataLoader,
    required this.displayText,
    required this.compareItems,
    required this.onSaveCallback,
    this.comboKey,
    this.initItem,
    this.onChangedCallback,
    this.validatorCallback,
    this.customItemBuilder,
    this.showClearButton = false,
    this.enableSearch = true,
    this.isEnabled = true,
    this.maxHeight = 300,
    this.prefixIcon,
    this.errorText,
  }) : super(key: key);

  @override
  State<ReusableComboBox<T>> createState() => _ReusableComboBoxState<T>();
}

class _ReusableComboBoxState<T> extends State<ReusableComboBox<T>> {
  List<T>? _cachedItems;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: widget.comboKey,
      enabled: widget.isEnabled,
      selectedItem: widget.initItem,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: bodyTextStyle(context),
        decoration: InputDecoration(
          labelText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          labelStyle: inputTextStyle(context),
          hintText: 'Pilih ${widget.hintText}',
          hintStyle: bodyTextStyle(context).copyWith(color: hintGrey),
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon, color: primaryColor) : null,
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

          // ERROR
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),

          errorStyle: bodyTextStyle(context).copyWith(
            color: Colors.red,
            fontSize: 12,
          ),

          errorText: (widget.errorText != null && widget.errorText!.trim().isNotEmpty)
              ? widget.errorText
              : null,
        ),
      ),
      // DATA LOADER
      items: (filter, infiniteScrollProps) async {
        try {
          final items = await widget.dataLoader();
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
          isVisible: widget.showClearButton,
          icon: Icon(Icons.clear, size: 16, color: primaryLightColor),
        ),
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
          iconOpened:Transform.rotate(
            angle: 180 * 3.1416 / 180,
            child: SvgPicture.asset(
              "assets/icons/dropdown.svg",
              width: 16,
            ),
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
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        showSelectedItems: true,
        showSearchBox: widget.enableSearch,
        itemBuilder: widget.customItemBuilder ?? _defaultItemBuilderWithDivider,
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
            widget.enableSearch
                ? TextFieldProps(
                  style: inputTextStyle(context, color: hintGrey),
                  cursorColor: primaryLightColor,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Cari ${widget.hintText}...',
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
      compareFn: widget.compareItems,
      itemAsString: widget.displayText,
      onChanged: widget.onChangedCallback,
      onSaved: widget.onSaveCallback,
      validator: (value) {
        if (widget.errorText != null && widget.errorText!.trim().isNotEmpty) {
          return null;
        }
        if (widget.validatorCallback != null) {
          final result = widget.validatorCallback!(value);
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
    final items = _cachedItems ?? [];
    final isFirstItem = items.isNotEmpty && widget.compareItems(item, items.first);
    final isLastItem = items.isNotEmpty && widget.compareItems(item, items.last);

    return Column(
      children: [
        if (isFirstItem) kDivider(color: sGrey),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.displayText(item), style: bodyTextStyle(context)),
          ),
        ),

        if (!isLastItem) kDivider(color: sGrey),
      ],
    );
  }

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
            child: Text(widget.displayText(item), style: bodyTextStyle(context)),
          ),
        ),
        kDivider(color: sGrey),
      ],
    );
  }
}
