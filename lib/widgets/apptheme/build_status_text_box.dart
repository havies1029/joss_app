import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusTextBox extends StatefulWidget {
  final String assetPath;
  final String? text;
  final Color? bgColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? activeIconColor;     // ⬅️ warna icon saat aktif
  final double height;
  final double iconSize;
  final double spacing;
  final double? fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final bool enableBorderClickFill;

  const StatusTextBox({
    super.key,
    required this.assetPath,
    this.text,
    this.bgColor,
    this.borderColor,
    this.iconColor,
    this.activeIconColor,          // ⬅️ opsional
    this.height = 40,
    this.iconSize = 18,
    this.spacing = 8,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.onTap,
    this.enableBorderClickFill = false,
  });

  @override
  State<StatusTextBox> createState() => _StatusTextBoxState();
}

class _StatusTextBoxState extends State<StatusTextBox> {
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
    final Color? effectiveBg = widget.borderColor != null
        ? (_isFilled ? widget.borderColor : Colors.transparent)
        : (widget.bgColor ?? Colors.transparent);

    final Color effectiveIconColor = _isFilled
        ? (widget.activeIconColor ?? Colors.white) // ⬅️ warna icon aktif
        : (widget.iconColor ?? primaryLightColor); // ⬅️ warna default

    return InkWell(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: widget.height,
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.assetPath,
              width: widget.iconSize,
              height: widget.iconSize,
              colorFilter: ColorFilter.mode(
                effectiveIconColor, // ⬅️ warna berubah sesuai state
                BlendMode.srcIn,
              ),
            ),
            if (widget.text != null && widget.text!.isNotEmpty) ...[
              SizedBox(width: widget.spacing),
              Text(
                widget.text!,
                style: TextStyle(
                  fontSize:
                  widget.fontSize ?? getResponsiveFont(context, 16),
                  fontWeight: widget.fontWeight,
                  color: primaryLightColor,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
