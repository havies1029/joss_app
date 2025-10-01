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
  final bool fullIcon;               // ⬅️ baru: icon segede container
  final bool showBorder;             // ⬅️ baru: toggle border

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
    this.fullIcon = false,            // default: false
    this.showBorder = true,           // default: true
  });

  @override
  State<StatusBox> createState() => _StatusBoxState();
}

class _StatusBoxState extends State<StatusBox> {
  bool _isFilled = false;

  void _handleTap() {
    if (widget.enableBorderClickFill && widget.borderColor != null) {
      setState(() {
        _isFilled = !_isFilled;
      });
    }
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPureIconMode = widget.fullIcon && !widget.showBorder && widget.enableBorderClickFill;

    final effectiveBg = widget.borderColor != null
        ? (_isFilled ? widget.borderColor : Colors.transparent)
        : (widget.bgColor ?? Colors.transparent);

    final effectiveIconColor = _isFilled
        ? (widget.activeIconColor ?? Colors.white)
        : (widget.iconColor ?? primaryLightColor);

    Widget content = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: effectiveBg, // ⬅️ tetap dipakai (biar bisa berubah saat toggle)
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
    );

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: _handleTap,
      child: content,
    );
  }

}
