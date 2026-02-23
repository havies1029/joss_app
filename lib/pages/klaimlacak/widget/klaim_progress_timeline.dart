import 'package:flutter/material.dart';
import 'klaim_progress_tile_styles.dart';

class KlaimProgressTimeline extends StatelessWidget {
  final bool isLast;
  final bool isLastActive;
  final Color dotColor;
  final Color lineColor;

  const KlaimProgressTimeline({
    super.key,
    required this.isLast,
    required this.isLastActive,
    required this.dotColor,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final lastActiveColor = KlaimProgressTileStyles.lastActiveColor;

    return SizedBox(
      width: 22,
      child: Column(
        children: [
          const SizedBox(height: 10),

          if (isLastActive)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: lastActiveColor.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(color: lastActiveColor.withOpacity(0.55), width: 1),
              ),
              child: Icon(
                Icons.lightbulb_rounded,
                size: 12,
                color: lastActiveColor.withOpacity(0.85),
              ),
            )
          else
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),

          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                color: lineColor,
              ),
            ),
        ],
      ),
    );
  }
}