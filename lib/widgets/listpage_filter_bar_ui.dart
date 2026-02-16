import 'dart:async';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListPageFilterBarUIWidget extends StatefulWidget {
  final TextEditingController searchController;
  final IconButton? searchButton;
  final Function(String)? onSearch;
  final String hintText;
  final Duration debounceDuration;

  const ListPageFilterBarUIWidget({
    super.key,
    required this.searchController,
    this.searchButton,
    this.onSearch,
    this.hintText = 'Cari...',
    this.debounceDuration = const Duration(milliseconds: 700),
  });

  @override
  State<ListPageFilterBarUIWidget> createState() =>
      _ListPageFilterBarUIWidgetState();
}

class _ListPageFilterBarUIWidgetState
    extends State<ListPageFilterBarUIWidget> {
  Timer? _debounce;

  void _triggerSearch(String value) {
    if (widget.onSearch != null) {
      widget.onSearch!(value);
    } else {
      widget.searchButton?.onPressed?.call();
    }
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(widget.debounceDuration, () {
      _triggerSearch(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: formGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/search_icon.svg",
                width: 16,
                height: 16,
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: widget.searchController,
              onChanged: _onChanged,
              onSubmitted: (_) =>
                  _triggerSearch(widget.searchController.text),
              style: TextStyle(color: primaryLightColor),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                TextStyle(color: primaryLightColor.withOpacity(0.6)),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
            ),
          ),

          SizedBox(
            width: 36,
            child: IconButton(
              icon:
              Icon(Icons.clear, size: 20, color: primaryLightColor),
              tooltip: 'Clear',
              onPressed: () {
                widget.searchController.clear();
                _triggerSearch("");
              },
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
