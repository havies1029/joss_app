import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

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

    return SizedBox(
      width: 22,
      child: Column(
        children: [
          const SizedBox(height: 10),

          if (isLastActive)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: pGreen,
                shape: BoxShape.circle,
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
