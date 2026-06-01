import 'package:flutter/material.dart';

import '../../common/constants.dart';

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
    final h = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(color: primaryBlackColor),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: h * 0.30,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  backgroundAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),

                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        primaryBlackColor,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        child,
      ],
    );
  }
}