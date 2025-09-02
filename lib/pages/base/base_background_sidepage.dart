import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black, // dasar hitam
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header Hitam
            Container(
              height: 56,
              color: primaryBlackColor, // pakai constant
              padding: const EdgeInsets.symmetric(horizontal: hPaddingForCard),
              child: Stack(
                children: [
                  // 🔙 Tombol back di kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack ?? () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: primaryLightColor),
                    ),
                  ),

                  // 🔹 Title di tengah
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: primaryLightColor,   // pakai constant
                        fontSize: getResponsiveFont(context, 20),               // bisa ganti ke constant kalau ada
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Background + Konten
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

                      // Konten bebas
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
        child: Text(
          "Konten di sini",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}