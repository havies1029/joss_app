import 'package:flutter/material.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // latar dasar hitam
      body: LayoutBuilder(
        builder: (context, c) {
          final cols = c.maxWidth < 380 ? 3 : 4;
          final fadeHeight = c.maxHeight * 0.45; // tinggi area gambar + fade

          return Stack(
            children: [
              // ====== Gambar di atas + fade ke hitam ======
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: fadeHeight,
                  width: double.infinity,
                  child: ShaderMask(
                    // putih = tampak, transparan = menghilang → blend ke bg #121212
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent],
                        stops: [0.0, 1.0], // ubah mis. [0.0, 0.85] kalau mau fade lebih panjang
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      "assets/images/background_gradient.png",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // ====== Konten grid di atas background ======
              GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  // item grid kamu di sini
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
