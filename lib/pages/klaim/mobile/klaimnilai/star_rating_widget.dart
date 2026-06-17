
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int value;
  final int max;
  final double size;
  final ValueChanged<int> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const StarRating({
    required this.value,
    required this.onChanged,
    this.size = 44,
    required this.activeColor,
    required this.inactiveColor,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(max, (i) {
        final idx = i + 1;
        final isOn = idx <= value;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(idx),
          child: Icon(
            isOn ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: isOn ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}