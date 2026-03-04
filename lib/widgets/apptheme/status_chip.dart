import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusChip extends StatelessWidget {
  final String assetPath;
  final String label;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusChip({
    super.key,
    required this.assetPath,
    required this.label,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? primaryColor : pGrey;
    final border = isSelected ? const Color(0xFF5D86FF) : const Color(0xFFBCBCC7);
    final textColor = isSelected ? Colors.white : primaryLightColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : iconColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: headingStyle(context, fontSize: 13).copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
