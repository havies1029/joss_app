part of '../../common/constants.dart';

enum ButtonLayoutType {
  textOnly,
  iconOnly,
  iconLeft,
  iconRight,
  iconTop,
  iconBottom,
}

class appButtons extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool hasAnimation;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final BorderSide? borderSide;
  final ButtonLayoutType layoutType;
  final double iconTextSpacing;
  final bool isSquare;
  final double? squareSize;

  const appButtons({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.style,
    this.textStyle,
    this.isLoading = false,
    this.hasAnimation = true,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.elevation,
    this.borderSide,
    this.layoutType = ButtonLayoutType.textOnly,
    this.iconTextSpacing = 8.0,
    this.isSquare = false,
    this.squareSize,
  }) : assert(
  text != null || icon != null,
  'Either text or icon must be provided',
  );

  // Factory untuk button biasa (text only)
  factory appButtons.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
  }) {
    return appButtons(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      layoutType: ButtonLayoutType.textOnly,
    );
  }

  // Factory untuk icon button persegi
  factory appButtons.iconSquare({
    required Widget icon,
    VoidCallback? onPressed,
    double? size,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return appButtons(
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: iconColor,
      layoutType: ButtonLayoutType.iconOnly,
      isSquare: true,
      squareSize: size,
    );
  }

  // Factory untuk button dengan icon di atas text (seperti di gambar)
  factory appButtons.iconTop({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? textColor,
    double iconTextSpacing = 8.0,
    bool isSquare = false,
    double? squareSize,
  }) {
    return appButtons(
      text: text,
      icon: icon,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      layoutType: ButtonLayoutType.iconTop,
      iconTextSpacing: iconTextSpacing,
      isSquare: isSquare,
      squareSize: squareSize,
    );
  }

  // Factory untuk button dengan icon di samping
  factory appButtons.iconLeft({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    double iconTextSpacing = 8.0,
  }) {
    return appButtons(
      text: text,
      icon: icon,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      layoutType: ButtonLayoutType.iconLeft,
      iconTextSpacing: iconTextSpacing,
    );
  }

  // Factory untuk secondary button (outline)
  factory appButtons.secondary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
  }) {
    return appButtons(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      backgroundColor: Colors.transparent,
      textColor: primaryColor,
      borderSide: BorderSide(color: primaryColor, width: 1.5),
      elevation: 0,
      layoutType: ButtonLayoutType.textOnly,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan ukuran button
    double? finalWidth = width;
    double? finalHeight = height;

    if (isSquare) {
      final size = squareSize ?? buttonHeight;
      finalWidth = size;
      finalHeight = size;
    }

    // Build button style
    ButtonStyle buttonStyle = style ?? ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? primaryColor,
      foregroundColor: textColor ?? primaryLightColor,
      maximumSize: Size(
          finalWidth ?? double.infinity,
          finalHeight ?? buttonHeight
      ),
      minimumSize: Size(
          finalWidth ?? (isSquare ? (squareSize ?? buttonHeight) : 0),
          finalHeight ?? buttonHeight
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? cardBorderRadius),
        ),
        side: borderSide ?? BorderSide.none,
      ),
      elevation: elevation ?? 0,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: isSquare ? 8 : 16,
        vertical: isSquare ? 8 : 10,
      ),
    );

    // Build text style
    TextStyle finalTextStyle = textStyle ?? TextStyle(
      color: textColor ?? primaryLightColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveFont(context, isSquare ? 12 : 18),
    );

    // Build button content berdasarkan layout type
    Widget buttonContent = _buildContent(finalTextStyle);

    // Build button
    Widget button = SizedBox(
      width: finalWidth,
      height: finalHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: buttonContent,
      ),
    );

    // Apply animation if enabled
    if (hasAnimation) {
      return button.animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1, 1),
            end: const Offset(0.95, 0.95),
            duration: kAnimationDuration,
          ),
        ],
      );
    }

    return button;
  }

  Widget _buildContent(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? primaryLightColor,
          ),
        ),
      );
    }

    switch (layoutType) {
      case ButtonLayoutType.textOnly:
        return Text(text ?? '', style: textStyle);

      case ButtonLayoutType.iconOnly:
        return icon ?? const SizedBox.shrink();

      case ButtonLayoutType.iconLeft:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            SizedBox(width: iconTextSpacing),
            Text(text ?? '', style: textStyle),
          ],
        );

      case ButtonLayoutType.iconRight:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text ?? '', style: textStyle),
            SizedBox(width: iconTextSpacing),
            icon ?? const SizedBox.shrink(),
          ],
        );

      case ButtonLayoutType.iconTop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            SizedBox(height: iconTextSpacing),
            Text(
              text ?? '',
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );

      case ButtonLayoutType.iconBottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ?? '',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: iconTextSpacing),
            icon ?? const SizedBox.shrink(),
          ],
        );
    }
  }
}