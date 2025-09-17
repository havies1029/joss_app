import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constants.dart';

class BaseBackgroundSidePage extends StatelessWidget {
  final Widget child;
  final double fadeHeight;
  final String backgroundAsset;
  final String title;
  final VoidCallback? onBack;

  const BaseBackgroundSidePage({
    super.key,
    required this.child,
    required this.title,
    this.onBack,
    this.fadeHeight = 300,
    this.backgroundAsset = "assets/images/background_gradient.png",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 56,
              color: primaryBlackColor,
              padding: const EdgeInsets.symmetric(horizontal: hPadding*2),
              child: Stack(
                children: [
                  // Tombol back di kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack ?? () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/arrow_back.svg"),
                    ),
                  ),

                  // Title
                  Center(
                    child: Text(
                      title,
                      style: headingStyle(context, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Background + konten
            Expanded(
              child: LayoutBuilder(
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
                                colors: [primaryLightColor, Colors.transparent],
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

                      // Konten
                      child,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KelolaProfilPage extends StatelessWidget {
  const KelolaProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kelola Profil",
      child: Center(
        child: Text("Konten di sini", style: bodyTextStyle(context)),
      ),
    );
  }
}
