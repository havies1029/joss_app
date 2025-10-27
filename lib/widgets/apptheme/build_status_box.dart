import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusChip extends StatefulWidget {
  final String assetPath;
  final String label;
  final String? count;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  final double iconSize;

  const StatusChip({
    super.key,
    required this.assetPath,
    required this.label,
    this.count,
    required this.iconColor,
    this.isSelected = false,
    required this.onTap,
    this.height = 34,
    this.iconSize = 16,
  });

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isJatuhTempo =
    widget.label.toLowerCase().contains("jatuh tempo");

    // 🔹 Tentukan path icon aktif vs non-aktif
    String iconPath = widget.assetPath;
    if (widget.isSelected) {
      if (widget.label.toLowerCase().contains("aktif")) {
        iconPath = "assets/icons/aktif_hover.svg";
      } else if (widget.label.toLowerCase().contains("non")) {
        iconPath = "assets/icons/nonaktif_hover.svg";
      } else if (widget.label.toLowerCase().contains("proses")) {
        iconPath = "assets/icons/diproses_hover.svg";
      } else if (widget.label.toLowerCase().contains("jatuh tempo")) {
        iconPath = "assets/icons/jatuhtempo_hover.svg";
      }
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 🔹 Container utama
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: widget.isSelected ? primaryColor : pGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconPath, // ✅ otomatis berubah sesuai isSelected
                    width: widget.iconSize,
                    height: widget.iconSize,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.count != null && widget.count!.isNotEmpty
                        ? "${widget.label} (${widget.count})"
                        : widget.label,
                    style: bodyTextStyle(context, fontSize: 13.2),
                  ),
                ],
              ),
            ),

            // 🔹 Badge khusus Jatuh Tempo
            if (isJatuhTempo)
              Positioned(
                top: -8,
                right: -2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    'H-60 hr',
                    style: bodyTextStyle(context, fontSize: 9.65),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}