import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class TablePagination extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onPageChange;

  const TablePagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    int maxVisible = screenWidth < 400
        ? 5
        : screenWidth < 700
        ? 7
        : screenWidth < 1200
        ? 9
        : 11;

    List<int> visiblePages = [];
    if (totalPages <= maxVisible) {
      visiblePages = List.generate(totalPages, (i) => i + 1);
    } else {
      int half = (maxVisible / 2).floor();
      int start = currentPage - half;
      int end = currentPage + half;
      if (start < 1) {
        end += (1 - start);
        start = 1;
      }
      if (end > totalPages) {
        start -= (end - totalPages);
        end = totalPages;
      }
      visiblePages = List.generate(end - start + 1, (i) => start + i);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _arrow(context, "<", enabled: currentPage > 1,
            onTap: () => onPageChange(currentPage - 1)),
        for (int i in visiblePages)
          _pageButton(context, i, i == currentPage, () => onPageChange(i)),
        _arrow(context, ">", enabled: currentPage < totalPages,
            onTap: () => onPageChange(currentPage + 1)),
      ],
    );
  }

  Widget _arrow(BuildContext ctx, String label,
      {required bool enabled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1.0 : 0.4,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: enabled ? secondaryBlackColor : sGrey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: sGrey.withOpacity(0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? primaryLightColor : sGrey.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageButton(BuildContext ctx, int num, bool active, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? primaryColor : secondaryBlackColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: active ? primaryColor : sGrey.withOpacity(0.6)),
        ),
        child: Text(
          "$num",
          style: TextStyle(
            color: active ? secondaryBlackColor : primaryLightColor,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
