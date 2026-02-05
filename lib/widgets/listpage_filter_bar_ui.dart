import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class ListPageFilterBarUIWidget extends StatelessWidget {
  final TextEditingController searchController;
  final IconButton searchButton;
  final String hintText;

  const ListPageFilterBarUIWidget({
    super.key,
    required this.searchController,
    required this.searchButton,
    this.hintText = 'Cari...',
  });

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
          // 🔍 kiri
          SizedBox(
            width: 36,
            child: IconButton(
              icon: Icon(Icons.search, color: primaryLightColor),
              tooltip: 'Cari data',
              onPressed: searchButton.onPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // 📝 input
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => searchButton.onPressed?.call(),
              style: TextStyle(color: primaryLightColor),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: primaryLightColor.withOpacity(0.6)),
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
              icon: Icon(Icons.clear, size: 20, color: primaryLightColor),
              tooltip: 'Hapus teks',
              onPressed: () => searchController.clear(),
              constraints: const BoxConstraints(),
            ),
          ),

          SizedBox(
            width: 36,
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: primaryLightColor,
              ),
              tooltip: 'Kirim pencarian',
              onPressed: searchButton.onPressed,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
