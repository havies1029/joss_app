import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusBox extends StatefulWidget {
  final String assetPath;
  final Color? bgColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? activeIconColor;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;
  final bool enableBorderClickFill;
  final bool fullIcon;   // icon segede container
  final bool showBorder; // toggle border

  const StatusBox({
    super.key,
    required this.assetPath,
    this.bgColor,
    this.borderColor,
    this.iconColor,
    this.activeIconColor,
    this.size = 36,
    this.iconSize = 18,
    this.onTap,
    this.enableBorderClickFill = false,
    this.fullIcon = false,
    this.showBorder = true,
  });

  @override
  State<StatusBox> createState() => _StatusBoxState();
}

class _StatusBoxState extends State<StatusBox> {
  bool _isFilled = false;
  bool _isPressed = false; // buat animasi klik

  void _handleTap() {
    if (widget.enableBorderClickFill && widget.borderColor != null) {
      setState(() {
        _isFilled = !_isFilled;
      });
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isPureIconMode =
        widget.fullIcon && !widget.showBorder && widget.enableBorderClickFill;

    final effectiveBg = widget.borderColor != null
        ? (_isFilled ? widget.borderColor : Colors.transparent)
        : (widget.bgColor ?? Colors.transparent);

    final effectiveIconColor = _isFilled
        ? (widget.activeIconColor ?? Colors.white)
        : (widget.iconColor ?? primaryLightColor);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isPressed ? 0.7 : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: BorderRadius.circular(6),
              border: (!isPureIconMode && widget.showBorder && widget.borderColor != null)
                  ? Border.all(color: widget.borderColor!, width: 1.5)
                  : null,
            ),
            child: Center(
              child: SvgPicture.asset(
                widget.assetPath,
                width: widget.fullIcon ? widget.size * 0.6 : widget.iconSize,
                height: widget.fullIcon ? widget.size * 0.6 : widget.iconSize,
                colorFilter: ColorFilter.mode(
                  effectiveIconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
