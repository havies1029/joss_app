
import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';

class ComboQuery {
  final String searchText;
  final Map<String, dynamic> params;

  const ComboQuery({
    this.searchText = '',
    this.params = const {},
  });

  T? get<T>(String key) => params[key] as T?;
}

class ReusableComboBoxV2<T> extends StatefulWidget {
  final String hintText;
  final GlobalKey<DropdownSearchState<T>>? comboKey;
  final T? initItem;
  final Function(T?)? onChangedCallback;
  final Function(T?) onSaveCallback;
  final String? Function(T?)? validatorCallback;

  final Future<List<T>> Function(ComboQuery query) loader;
  final Map<String, dynamic> params;

  final String Function(T) displayText;
  final bool Function(T, T) compareItems;
  final Widget Function(BuildContext, T, bool, bool)? customItemBuilder;

  final Duration searchDebounce;
  final int minSearchChars;
  final bool showClearButton;
  final bool enableSearch;
  final bool isEnabled;
  final double maxHeight;
  final IconData? prefixIcon;
  final String? errorText;

  /// dipakai untuk mendeteksi perubahan parent filter
  /// mis: dependencyKey: selectedProvinceCode
  final Object? dependencyKey;

  /// kalau dependency berubah, widget akan clear cache
  final bool clearCacheOnDependencyChange;

  final bool clientSideSearch;

  const ReusableComboBoxV2({
    super.key,
    required this.hintText,
    required this.loader,
    required this.displayText,
    required this.compareItems,
    required this.onSaveCallback,
    this.comboKey,
    this.initItem,
    this.onChangedCallback,
    this.validatorCallback,
    this.customItemBuilder,
    this.params = const {},
    this.showClearButton = false,
    this.enableSearch = true,
    this.isEnabled = true,
    this.maxHeight = 300,
    this.prefixIcon,
    this.errorText,
    this.searchDebounce = const Duration(milliseconds: 350),
    this.minSearchChars = 0,
    this.dependencyKey,
    this.clearCacheOnDependencyChange = true,
    this.clientSideSearch = false,
  });

  @override
  State<ReusableComboBoxV2<T>> createState() => _ReusableComboBoxV2State<T>();
}

class _ReusableComboBoxV2State<T> extends State<ReusableComboBoxV2<T>> {
  List<T>? _cachedItems;
  Timer? _debounceTimer;
  int _reqSeq = 0;

  @override
  void didUpdateWidget(covariant ReusableComboBoxV2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final dependencyChanged = oldWidget.dependencyKey != widget.dependencyKey;

    if (dependencyChanged && widget.clearCacheOnDependencyChange) {
      _cachedItems = null;

      // optional: clear internal dropdown state
      widget.comboKey?.currentState?.clear();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<List<T>> _loadItems(String rawFilter) async {
    final q = rawFilter.trim();

    if (!widget.enableSearch) {
      final items = await widget.loader(
        ComboQuery(searchText: '', params: widget.params),
      );
      _cachedItems = items;
      return items;
    }

    if (q.isNotEmpty && q.length < widget.minSearchChars) {
      _cachedItems = const [];
      return const [];
    }

    if (widget.clientSideSearch) {
      final baseItems = _cachedItems ??
          await widget.loader(
            ComboQuery(searchText: '', params: widget.params),
          );

      final filteredItems = q.isEmpty
          ? baseItems
          : baseItems.where((item) {
        final text = widget.displayText(item).toLowerCase();
        final keyword = q.toLowerCase();
        return text.contains(keyword);
      }).toList();

      _cachedItems = baseItems;
      return filteredItems;
    }

    if (q.isEmpty) {
      final items = await widget.loader(
        ComboQuery(searchText: '', params: widget.params),
      );
      _cachedItems = items;
      return items;
    }

    final completer = Completer<List<T>>();
    _debounceTimer?.cancel();
    final int mySeq = ++_reqSeq;

    _debounceTimer = Timer(widget.searchDebounce, () async {
      try {
        final result = await widget.loader(
          ComboQuery(searchText: q, params: widget.params),
        );

        if (mySeq != _reqSeq) {
          if (!completer.isCompleted) completer.complete(const []);
          return;
        }

        _cachedItems = result;
        if (!completer.isCompleted) completer.complete(result);
      } catch (_) {
        if (!completer.isCompleted) completer.complete(const []);
      }
    });

    return completer.future;
  }

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
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: primaryColor)
              : null,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
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
      items: (filter, infiniteScrollProps) => _loadItems(filter ?? ''),
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          isVisible: widget.showClearButton,
          icon: Icon(Icons.clear, size: 16, color: primaryLightColor),
        ),
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
          iconOpened: Transform.rotate(
            angle: 180 * 3.1416 / 180,
            child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
          ),
          isVisible: true,
        ),
      ),
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(
          margin: EdgeInsets.only(top: 5),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        loadingBuilder: (context, searchEntry) {
          return const Center(child: LoadingIndicator());
        },
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        showSelectedItems: true,
        showSearchBox: widget.enableSearch,
        itemBuilder: widget.customItemBuilder ?? _defaultItemBuilderWithDivider,
        containerBuilder: (context, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              color: formGrey,
              border: Border.all(color: sGrey),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(cardBorderRadius),
              ),
            ),
            child: popupWidget,
          );
        },
        searchFieldProps: widget.enableSearch
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
}