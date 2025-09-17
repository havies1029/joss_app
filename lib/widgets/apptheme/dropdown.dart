part of '../../common/constants.dart';

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
    this.borderRadius = 10,
  }) : super(key: key);

  Color get _mainColor => color ?? primaryColor;
  Color get _bkgColor => backgroundColor ?? formGrey;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: comboKey,
      enabled: isEnabled,
      selectedItem: initItem,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: bodyTextStyle(context),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: _mainColor) : null,
          suffixIcon: Icon(Icons.arrow_drop_down, color: _mainColor),
          filled: true,
          fillColor: _bkgColor,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            borderSide: BorderSide(color: sGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            borderSide: BorderSide(color: sGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            borderSide: BorderSide(color: _mainColor),
          ),
          // contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
        showSelectedItems: true,
        showSearchBox: !disableFilter,
        itemBuilder: _cityStyleItemBuilder,
        containerBuilder: (context, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              color: formGrey,
              border: Border.all(color: sGrey),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: popupWidget,
          );
        },
        searchFieldProps: TextFieldProps(
          style: inputTextStyle(context, color: hintGrey),
          cursorColor: primaryLightColor,
          decoration: InputDecoration(
            isDense: true, // biar lebih rapat
            hintText: searchHintText,
            hintStyle: inputTextStyle(context, color: hintGrey),
            prefixIcon: Icon(Icons.search, color: hintGrey, size: 18),
            filled: true,
            fillColor: formGrey,
            // contentPadding: const EdgeInsets.symmetric(vertical: 12), // align teks
            border: InputBorder.none,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 20,
            ),
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

  Widget _cityStyleItemBuilder(
      BuildContext context,
      T item,
      bool isSelected,
      bool isDisabled,
      ) {
    return Column(
      children: [
        // Hanya teks yang ada padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              displayText(item),
              style: bodyTextStyle(context),
            ),
          ),
        ),

        // Divider full width (tanpa padding horizontal)
        sDivider,
      ],
    );
  }

}