import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableActionButton extends StatelessWidget {
  final String asset;
  final Color bgColor;
  final VoidCallback onTap;

  const TableActionButton({
    super.key,
    required this.asset,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 5,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 16,
            height: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
