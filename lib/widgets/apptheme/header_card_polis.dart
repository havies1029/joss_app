import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class FormSectionHeader extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;

  const FormSectionHeader({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.iconSize = 40,
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: borderColor ?? sGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Icon SVG
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          const SizedBox(width: 10),

          // 🔹 Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                Text(
                  subtitle,
                  style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
