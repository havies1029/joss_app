import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusTextBox extends StatelessWidget {
  final String assetPath;
  final String text;
  final Color bgColor;
  final double height;
  final double iconSize;
  final double spacing;
  final VoidCallback? onTap;

  const StatusTextBox({
    super.key,
    required this.assetPath,
    required this.text,
    required this.bgColor,
    this.height = 40,      // default tinggi
    this.iconSize = 18,    // default ukuran icon
    this.spacing = 8,      // jarak icon <-> text
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                primaryLightColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: spacing),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: primaryLightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
