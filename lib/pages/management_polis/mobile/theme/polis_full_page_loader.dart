import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:joss_app/common/constants.dart';

class PolisFullPageLoaderOverlay extends StatelessWidget {
  const PolisFullPageLoaderOverlay({
    super.key,
    required this.visible,
    this.size = 56,
    this.fadeDuration = const Duration(milliseconds: 180),
  });

  final bool visible;
  final double size;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: fadeDuration,
        curve: Curves.easeOut,
        child: Container(
          color: secondaryBlackColor.withOpacity(0.92),
          alignment: Alignment.center,
          child: SizedBox(
            width: size,
            height: size,
            child: Lottie.asset(
              'assets/icons/infinity_loader_orange.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
