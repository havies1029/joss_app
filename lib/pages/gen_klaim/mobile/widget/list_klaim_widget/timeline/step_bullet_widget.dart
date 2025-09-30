
import 'package:flutter/cupertino.dart';

import '../../../../../../common/constants.dart';

class StepBulletWithText extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;

  const StepBulletWithText({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran yang lebih proporsional untuk mobile
    const double bulletSize = 56;
    const double innerSize = 44;
    const double iconSize = 24;

    // Determine colors based on state
    Color bulletColor;
    Color iconColor;
    Color textColor;

    if (isActive) {
      // Current active step - orange
      bulletColor = primaryColor;
      iconColor = primaryLightColor;
      textColor = primaryLightColor;
    } else if (isDone) {
      // Completed step - orange
      bulletColor = primaryColor;
      iconColor = primaryLightColor;
      textColor = primaryLightColor;
    } else {
      // Future step - grey
      bulletColor = pGrey;
      iconColor = unselectedColor;
      textColor = unselectedColor;
    }

    return Container(
      width: 90, // 50% lebih pendek dari 180 -> 90
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bullet circle - centered in the 90px width
          Center(
            child: Container(
              width: bulletSize,
              height: bulletSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bulletColor,
                // Add subtle shadow for depth
                boxShadow: (isActive || isDone) ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bulletColor,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Label text - centered
          Container(
            width: 80, // Disesuaikan dengan container width yang lebih kecil
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}