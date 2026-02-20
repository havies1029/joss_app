import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineItem<T> extends StatelessWidget {
  final T item;
  final int index;

  final int activeIndex;

  final DateTime? Function(T item) getDateTime;
  final String Function(T item) getStatusText;

  final Color activeTextColor;
  final Color normalTextColor;
  final Color activeDotColor;
  final Color normalDotColor;
  final bool isLast;
  final bool hideLineWhenActive;
  final double lineHeight;
  final double dotSize;
  final double dateColumnWidth;
  final double gap;

  const TimelineItem({
    super.key,
    required this.item,
    required this.index,
    required this.isLast,
    required this.activeIndex,
    required this.getDateTime,
    required this.getStatusText,
    required this.activeTextColor,
    required this.normalTextColor,
    required this.activeDotColor,
    required this.normalDotColor,
    this.hideLineWhenActive = false,
    this.lineHeight = 30,
    this.dotSize = 12,
    this.dateColumnWidth = 82,
    this.gap = 5,
  });

  @override
  Widget build(BuildContext context) {
    final dt = getDateTime(item);
    final dateText = dt == null ? '' : DateFormat('dd MMM yyyy,').format(dt);
    final timeText = dt == null ? '' : DateFormat('HH:mm:ss').format(dt);
    final status = getStatusText(item);

    final isActive = index == activeIndex;

    final textColor = isActive ? activeTextColor : normalTextColor;
    final dotColor = isActive ? activeDotColor : normalDotColor;

    final showLine = !isLast;

    final lineColor = isActive ? activeDotColor : normalDotColor; // bisa kamu ubah kalau mau selalu normal

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: dateColumnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateText,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
              Text(
                timeText,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(width: gap),
        Column(
          children: [
            // dot
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),

            // line
            if (showLine)
              Container(
                width: 1.26,
                height: lineHeight,
                color: lineColor,
              ),
          ],
        ),
        SizedBox(width: gap),
        Expanded(
          child: Text(
            status,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
