import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusChip extends StatefulWidget {
  final String assetPath;
  final String label;
  final String count;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  final double iconSize;

  const StatusChip({
    super.key,
    required this.assetPath,
    required this.label,
    required this.count,
    required this.iconColor,
    this.isSelected = false,
    required this.onTap,
    this.height = 26,
    this.iconSize = 14.2,
  });

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isJatuhTempo = widget.label.toLowerCase().contains(
      "jatuh tempo",
    );
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
          clipBehavior: Clip.antiAlias,
          children: [
            // Main chip container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.height,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.isSelected ? sGrey : pGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  SvgPicture.asset(
                    widget.assetPath,
                    width: widget.iconSize,
                    height: widget.iconSize,
                  ),
                  const SizedBox(width: 2),
                  // Label
                  Text(
                    "${widget.label} (${widget.count})",
                    style: bodyTextStyle(context, fontSize: 12),
                  ),
                ],
              ),
            ),

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
                    color: const Color(0xFFFEBC2F),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(0),
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
