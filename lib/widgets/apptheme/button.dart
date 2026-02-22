part of '../../common/constants.dart';

enum ButtonLayoutType {
  textOnly,
  iconOnly,
  iconLeft,
  iconRight,
  iconTop,
  iconBottom,
}

class AppButton extends StatefulWidget {
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
    this.borderRadius,
    this.elevation,
    this.borderSide,
    this.layoutType = ButtonLayoutType.textOnly,
    this.iconTextSpacing = 8.0,
    this.isSquare = false,
    this.squareSize,
    this.isOutlined = false,
  });

  // Factory constructor untuk button text saja
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
    BorderSide? borderside,
    EdgeInsets? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool hasAnimation = true,
    bool isOutlined = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      borderSide: borderside,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      isOutlined: isOutlined,
      layoutType: ButtonLayoutType.textOnly,
    );
  }

  // Factory constructor untuk button icon saja
  factory AppButton.icon({
    required Widget icon,
    VoidCallback? onPressed,
    double? squareSize,
    Color? backgroundColor,
    Color? iconColor,
    double? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    bool isLoading = false,
    bool hasAnimation = true,
    bool isOutlined = false,
  }) {
    return AppButton(
      icon: icon,
      onPressed: onPressed,
      width: squareSize,
      height: squareSize,
      backgroundColor: backgroundColor,
      textColor: iconColor,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      isOutlined: isOutlined,
      layoutType: ButtonLayoutType.iconOnly,
      isSquare: true,
      squareSize: squareSize,
    );
  }

  // Factory constructor untuk button dengan icon di kiri
  factory AppButton.iconLeft({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double iconTextSpacing = 8.0,
    bool isLoading = false,
    bool hasAnimation = true,
    bool isOutlined = false,
    BorderSide? borderSide,
  }) {
    return AppButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      iconTextSpacing: iconTextSpacing,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      isOutlined: isOutlined,
      borderSide: borderSide,
      layoutType: ButtonLayoutType.iconLeft,
    );
  }

  // Factory constructor untuk button dengan icon di kanan
  factory AppButton.iconRight({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double iconTextSpacing = 8.0,
    bool isLoading = false,
    bool hasAnimation = true,
    bool isOutlined = false,
  }) {
    return AppButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      iconTextSpacing: iconTextSpacing,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      isOutlined: isOutlined,
      layoutType: ButtonLayoutType.iconRight,
    );
  }

  // Factory constructor untuk button dengan icon di atas
  factory AppButton.iconTop({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double iconTextSpacing = 8.0,
    bool isLoading = false,
    bool hasAnimation = true,
    bool isOutlined = false,
    BorderSide? borderSide,
  }) {
    return AppButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      iconTextSpacing: iconTextSpacing,
      isLoading: isLoading,
      hasAnimation: hasAnimation,
      isOutlined: isOutlined,
      borderSide: borderSide,
      layoutType: ButtonLayoutType.iconTop,
    );
  }

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.hasAnimation && widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.hasAnimation) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.hasAnimation) {
      _animationController.reverse();
    }
  }

  Widget _buildButtonChild() {
    if (widget.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.textColor ?? Colors.white,
          ),
        ),
      );
    }

    switch (widget.layoutType) {
      case ButtonLayoutType.textOnly:
        return Text(
          widget.text ?? '',
          style: _getTextStyle(),
        );

      case ButtonLayoutType.iconOnly:
        return widget.icon ?? const Icon(Icons.add);

      case ButtonLayoutType.iconLeft:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.icon ?? const Icon(Icons.add),
            SizedBox(width: widget.iconTextSpacing),
            Text(
              widget.text ?? '',
              style: _getTextStyle(),
            ),
          ],
        );

      case ButtonLayoutType.iconRight:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text ?? '',
              style: _getTextStyle(),
            ),
            SizedBox(width: widget.iconTextSpacing),
            widget.icon ?? const Icon(Icons.add),
          ],
        );

      case ButtonLayoutType.iconTop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.icon ?? const Icon(Icons.add),
            SizedBox(height: widget.iconTextSpacing),
            Text(
              widget.text ?? '',
              style: _getTextStyle(),
            ),
          ],
        );

      case ButtonLayoutType.iconBottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text ?? '',
              style: _getTextStyle(),
            ),
            SizedBox(height: widget.iconTextSpacing),
            widget.icon ?? const Icon(Icons.add),
          ],
        );
    }
  }

  TextStyle _getTextStyle() {
    return widget.textStyle ??
        bodyTextStyle(context);
  }

  ButtonStyle _getButtonStyle() {
    if (widget.style != null) return widget.style!;

    final borderRadius = widget.borderRadius ?? cardBorderRadius;
    final backgroundColor = widget.backgroundColor ?? primaryColor;
    final elevation = widget.elevation ?? 0.0;

    if (widget.isOutlined) {
      return OutlinedButton.styleFrom(
        foregroundColor: widget.textColor ?? backgroundColor,
        side: widget.borderSide ?? BorderSide(color: backgroundColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        backgroundColor: widget.backgroundColor,
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 5),
      );
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: widget.textColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: widget.borderSide ?? BorderSide.none,
      ),
      elevation: elevation,
      padding: widget.padding ?? EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.hasAnimation ? _scaleAnimation.value : 1.0,
          child: child,
        );
      },
      child: _buildButtonChild(),
    );

    final button = widget.isOutlined
        ? OutlinedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: _getButtonStyle(),
      child: buttonChild,
    )
        : ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: _getButtonStyle(),
      child: buttonChild,
    );

    Widget wrappedButton = SizedBox(
      width: widget.isSquare ? widget.squareSize : (widget.width ?? double.infinity),
      height: widget.isSquare ? widget.squareSize : (widget.height ?? buttonHeight),
      child: button,
    );

    if (widget.hasAnimation) {
      wrappedButton = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: wrappedButton,
      );
    }

    return wrappedButton;
  }
}