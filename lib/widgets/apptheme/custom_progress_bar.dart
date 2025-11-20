import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;
  final double horizontalPadding;
  final Color barColor;
  final Color textColor;
  final double barHeight;
  final double borderRadius;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.horizontalPadding = 16,
    this.barColor = Colors.blue,
    this.textColor = Colors.white,
    this.barHeight = 10,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          // === Progress Bar ===
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: barHeight,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // === Label Persen ===
          Text(
            "${(progress * 100).round()}%",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
