import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineItem<T> extends StatelessWidget {
  final T item;
  final bool isLast;

  final DateTime Function(T item) getDateTime;
  final String Function(T item) getStatusText;

  final Color lastTextColor;
  final Color normalTextColor;
  final Color lastDotColor;
  final Color normalDotColor;

  const TimelineItem({
    super.key,
    required this.item,
    required this.isLast,
    required this.getDateTime,
    required this.getStatusText,
    required this.lastTextColor,
    required this.normalTextColor,
    required this.lastDotColor,
    required this.normalDotColor,
  });

  @override
  Widget build(BuildContext context) {
    final dt = getDateTime(item);
    final status = getStatusText(item);

    final textColor = isLast ? lastTextColor : normalTextColor;
    final dotColor = isLast ? lastDotColor : normalDotColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy,').format(dt),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('HH:mm:ss').format(dt),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Column(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: dotColor,
            ),
            if (!isLast)
              Container(
                width: 1.26,
                height: 30,
                color: normalDotColor,
              ),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
