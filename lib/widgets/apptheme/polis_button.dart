import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class PolisButton extends StatelessWidget {
  final String assetPath;
  final String? text; // 🔥 ubah jadi nullable
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
    this.text, // 🔥 gak wajib lagi
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
    final iconWidget = SvgPicture.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      color: textColor ?? primaryLightColor,
    );

    final button = (text == null || text!.isEmpty)
        ? Material(
      color: bgColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 0.8,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: width ?? height,
          child: Center(child: iconWidget),
        ),
      ),
    )
        : AppButton.iconLeft(
      text: text!,
      icon: iconWidget,
      iconTextSpacing: 4,
      onPressed: onTap,
      height: height,
      padding: const EdgeInsets.all(10),
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