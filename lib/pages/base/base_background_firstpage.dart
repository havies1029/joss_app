import 'package:flutter/material.dart';

class BaseBackgroundFirstPage extends StatelessWidget {
  final Widget child;
  final double fadeHeight;
  final String backgroundAsset;

  const BaseBackgroundFirstPage({
    super.key,
    required this.child,
    this.fadeHeight = 300,
    this.backgroundAsset = "assets/images/background_gradient.png",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: fadeHeight,
            width: double.infinity,
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),

        child,
      ],
    );
  }
}