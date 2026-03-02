
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusChip extends StatefulWidget {
  final String statusId;
  final String label;
  final String? count;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  final double iconSize;
  final bool showIcon;

  const StatusChip({
    super.key,
    required this.statusId,
    required this.label,
    this.count,
    this.isSelected = false,
    required this.onTap,
    this.height = 34,
    this.iconSize = 16,
    this.showIcon = true,
  });

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip> {
  bool _isPressed = false;

  String _normalIconByStatusId(String id) {
    switch (id) {
      case "10001":
      case "10":
        return "assets/icons/aktif.svg";
      case "10002":
      case "20":
        return "assets/icons/diproses.svg";
      case "10003":
      case "30":
        return "assets/icons/nonaktif.svg";
      case "10004":
        return "assets/icons/jatuhtempo.svg";
      default:
        return "assets/icons/no_data.svg";
    }
  }

  String _activeIconByStatusId(String id) {
    switch (id) {
      case "10001":
      case "10":
        return "assets/icons/aktif_hover.svg";
      case "10002":
      case "20":
        return "assets/icons/diproses_hover.svg";
      case "10003":
      case "30":
        return "assets/icons/nonaktif_hover.svg";
      case "10004":
        return "assets/icons/jatuhtempo_hover.svg";
      default:
        return "assets/icons/no_data.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String iconPath = widget.isSelected
        ? _activeIconByStatusId(widget.statusId)
        : _normalIconByStatusId(widget.statusId);

    final String textLabel =
    (widget.count != null && widget.count!.isNotEmpty)
        ? "${widget.label} (${widget.count})"
        : widget.label;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
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
              if (widget.showIcon) ...[
                SvgPicture.asset(
                  iconPath,
                  width: widget.iconSize,
                  height: widget.iconSize,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                textLabel,
                style: bodyTextStyle(context, fontSize: 13.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}