import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class PolisButton extends StatelessWidget {
  final String assetPath;
  final String text;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;
  final double iconSize;
  final double height;
  final TextStyle? textStyle;

  const PolisButton({
    super.key,
    required this.assetPath,
    required this.text,
    this.onTap,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 8,
    this.iconSize = 12,
    this.height = 30  ,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.iconLeft(
      text: text,
      icon: SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        color: textColor ?? primaryLightColor,
      ),
      onPressed: onTap,
      height: height,
      backgroundColor: bgColor ?? Colors.transparent,
      borderRadius: borderRadius,
      isOutlined: true,
      borderSide: BorderSide(
        color: borderColor ?? primaryLightColor,
        width: 0.5,
      ),
      textStyle: textStyle ??
          bodyTextStyle(context, fontSize: 12),
    );
  }
}
