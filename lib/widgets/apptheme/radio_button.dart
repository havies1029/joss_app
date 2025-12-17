import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class RadioButton extends StatelessWidget {
  final bool isSelected;
  final double size;
  final double innerSize;
  final Color selectedColor;
  final Color unselectedColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const RadioButton({
    super.key,
    required this.isSelected,
    this.size = 15,
    this.innerSize = 9,
    this.selectedColor = primaryColor,
    this.unselectedColor = sGrey,
    this.borderWidth = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? selectedColor : unselectedColor,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? selectedColor : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
