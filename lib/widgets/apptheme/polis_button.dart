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
  final double? width;
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
    this.height = 30,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final button = AppButton.iconLeft(
      text: text,
      icon: SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        color: textColor ?? primaryLightColor,
      ),
      iconTextSpacing: 4,
      onPressed: onTap,
      height: height,
      padding: EdgeInsets.all(10),
      backgroundColor: bgColor ?? Colors.transparent,
      borderRadius: borderRadius,
      isOutlined: true,
      borderSide: BorderSide(
        color: borderColor ?? primaryLightColor,
        width: 0.5,
      ),
      textStyle: textStyle ??
          bodyTextStyle(
            context,
            fontSize: 12,
          ),
    );

    if (width != null) {
      return SizedBox(width: width, height: height, child: button);
    } else {
      return IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: button,
        ),
      );
    }
  }
}
