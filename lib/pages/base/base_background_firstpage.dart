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
    return LayoutBuilder(
      builder: (context, c) {
        final double height = c.maxHeight * 0.45;

        return Stack(
          children: [
            // Background dengan fade
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: fadeHeight > 0 ? fadeHeight : height,
                width: double.infinity,
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.transparent],
                      stops: [0.0, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    backgroundAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Konten halaman
            child,
          ],
        );
      },
    );
  }
}
