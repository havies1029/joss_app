part of '../../common/constants.dart';

enum ButtonLayoutType {
  textOnly,
  iconOnly,
  iconLeft,
  iconRight,
  iconTop,
  iconBottom,
}

class AppButton extends StatelessWidget {
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
  final Color? iconColor;
  final double? borderRadius;
  final double? elevation;
  final BorderSide? borderSide;
  final ButtonLayoutType layoutType;
  final double iconTextSpacing;
  final bool isSquare;
  final double? squareSize;
  final bool isOutlined;

  const AppButton({
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
    this.iconColor,
    this.borderRadius,
    this.elevation,
    this.borderSide,
    this.layoutType = ButtonLayoutType.textOnly,
    this.iconTextSpacing = 8.0,
    this.isSquare = false,
    this.squareSize,
    this.isOutlined = false,
  }) : assert(
         text != null || icon != null,
         'AppButton: Either text or icon must be provided',
       );

  // =========================
  //     FACTORY METHODS
  // =========================

  /// Primary Button
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      layoutType: ButtonLayoutType.textOnly,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      elevation: elevation,
      isOutlined: false,
    );
  }

  /// Outlined/Secondary Button
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? borderColor,
    double? borderRadius,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      layoutType: ButtonLayoutType.textOnly,
      textStyle: textStyle,
      backgroundColor: Colors.transparent,
      textColor: borderColor ?? primaryColor,
      iconColor: borderColor ?? primaryColor,
      borderSide: BorderSide(color: borderColor ?? primaryColor, width: 1.5),
      borderRadius: borderRadius,
      elevation: 0,
      isOutlined: true,
    );
  }

  /// Icon-only (Square)
  factory AppButton.iconSquare({
    required Widget icon,
    VoidCallback? onPressed,
    double? size,
    bool isLoading = false,
    bool hasAnimation = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? iconColor,
    double? borderRadius,
    double? elevation,
  }) {
    return AppButton(
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      padding: padding,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      layoutType: ButtonLayoutType.iconOnly,
      isSquare: true,
      squareSize: size,
      borderRadius: borderRadius,
      elevation: elevation,
    );
  }

  /// Icon Top
  factory AppButton.iconTop({
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
    Color? iconColor,
    double iconTextSpacing = 8.0,
    double? borderRadius,
    double? elevation,
    TextStyle? textStyle,
  }) {
    return AppButton(
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
      iconColor: iconColor,
      layoutType: ButtonLayoutType.iconTop,
      iconTextSpacing: iconTextSpacing,
      borderRadius: borderRadius,
      elevation: elevation,
      textStyle: textStyle,
    );
  }

  /// Icon Left
  factory AppButton.iconLeft({
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
    Color? iconColor,
    double iconTextSpacing = 8.0,
    double? borderRadius,
    double? elevation,
    TextStyle? textStyle,
  }) {
    return AppButton(
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
      iconColor: iconColor,
      layoutType: ButtonLayoutType.iconLeft,
      iconTextSpacing: iconTextSpacing,
      borderRadius: borderRadius,
      elevation: elevation,
      textStyle: textStyle,
    );
  }

  // ================
  //     BUILD
  // ================

  @override
  Widget build(BuildContext context) {
    double? finalWidth = width;
    double? finalHeight = height;
    if (isSquare) {
      final size = squareSize ?? buttonHeight;
      finalWidth = size;
      finalHeight = size;
    }

    // If user supplies style, use it *directly* (no merge)
    final bool useOutlined = isOutlined;
    final ButtonStyle? baseStyle =
        style ??
        (useOutlined
            ? OutlinedButton.styleFrom(
              foregroundColor: textColor ?? primaryColor,
              side: borderSide ?? BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? cardBorderRadius),
                ),
              ),
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: isSquare ? 8 : 16,
                    vertical: isSquare ? 8 : 10,
                  ),
              minimumSize: Size(
                finalWidth ?? (isSquare ? (squareSize ?? buttonHeight) : 0),
                finalHeight ?? buttonHeight,
              ),
              maximumSize: Size(
                finalWidth ?? double.infinity,
                finalHeight ?? buttonHeight,
              ),
              elevation: elevation ?? 0,
            )
            : ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? primaryColor,
              foregroundColor: textColor ?? primaryLightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? cardBorderRadius),
                ),
                side: borderSide ?? BorderSide.none,
              ),
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: isSquare ? 8 : 16,
                    vertical: isSquare ? 8 : 10,
                  ),
              minimumSize: Size(
                finalWidth ?? (isSquare ? (squareSize ?? buttonHeight) : 0),
                finalHeight ?? buttonHeight,
              ),
              maximumSize: Size(
                finalWidth ?? double.infinity,
                finalHeight ?? buttonHeight,
              ),
              elevation: elevation ?? 0,
            ));

    // Build text style
    final TextStyle finalTextStyle =
        textStyle ??
        TextStyle(
          color: textColor ?? (useOutlined ? primaryColor : primaryLightColor),
          fontWeight: FontWeight.w600,
          fontSize: getResponsiveFont(context, isSquare ? 13 : 17),
        );

    // Build button content
    final Widget buttonContent = _ButtonContent(
      layoutType: layoutType,
      text: text,
      icon: icon,
      isLoading: isLoading,
      iconColor:
          iconColor ??
          textColor ??
          (useOutlined ? primaryColor : primaryLightColor),
      textStyle: finalTextStyle,
      iconTextSpacing: iconTextSpacing,
    );

    Widget button = SizedBox(
      width: finalWidth,
      height: finalHeight,
      child:
          useOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: baseStyle,
                child: buttonContent,
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: baseStyle,
                child: buttonContent,
              ),
    );

    // Animation
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
}

/// Widget builder untuk konten button (reusable, lebih clean!)
class _ButtonContent extends StatelessWidget {
  final ButtonLayoutType layoutType;
  final String? text;
  final Widget? icon;
  final bool isLoading;
  final Color iconColor;
  final TextStyle textStyle;
  final double iconTextSpacing;

  const _ButtonContent({
    required this.layoutType,
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.iconColor,
    required this.textStyle,
    required this.iconTextSpacing,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
        ),
      );
    }
    switch (layoutType) {
      case ButtonLayoutType.textOnly:
        return Text(
          text ?? '',
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      case ButtonLayoutType.iconOnly:
        return _iconWidget();
      case ButtonLayoutType.iconLeft:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconWidget(),
            SizedBox(width: iconTextSpacing),
            Flexible(
              child: Text(
                text ?? '',
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        );
      case ButtonLayoutType.iconRight:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text ?? '',
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: iconTextSpacing),
            _iconWidget(),
          ],
        );
      case ButtonLayoutType.iconTop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconWidget(),
            SizedBox(height: iconTextSpacing),
            Text(
              text ?? '',
              style: textStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: iconTextSpacing),
            _iconWidget(),
          ],
        );
    }
  }

  Widget _iconWidget() {
    if (icon == null) return const SizedBox.shrink();
    return IconTheme(
      data: IconThemeData(color: iconColor, size: 22),
      child: icon!,
    );
  }
}
