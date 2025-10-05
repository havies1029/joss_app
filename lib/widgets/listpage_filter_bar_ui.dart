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
    this.hintText = 'Cari ...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: formGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // 🔍 kiri
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white70),
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                isDense: true, // ✅ bikin teks & hint center secara vertikal
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),

          // ❌ clear
          SizedBox(
            width: 36,
            child: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
              tooltip: 'Hapus teks',
              onPressed: () => searchController.clear(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // ➡️ kirim
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_rounded,
                  size: 24, color: Colors.white),
              tooltip: 'Kirim pencarian',
              onPressed: searchButton.onPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
