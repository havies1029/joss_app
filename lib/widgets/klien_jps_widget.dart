import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import '../blocs/gallery/gallerymembercari_bloc.dart';

class ClientSection extends StatefulWidget {
  const ClientSection({super.key});

  @override
  State<ClientSection> createState() => _ClientSectionState();
}

class _ClientSectionState extends State<ClientSection> {
  final PageController _pageController = PageController(viewportFraction: 0.33); // tampil ±3 logo
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    context.read<GallerymemberCariBloc>().add(RefreshGallerymemberCariEvent());

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % 6; // muter ke 6 logo
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/badge.svg', height: 24),
              const SizedBox(width: 6),
              Text(
                "Resmi, Aman dan Terpercaya",
                style: bodyTextStyle(context, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: 5),
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(cardBorderRadius),
              border: Border.all(color: sGrey),
            ),
            child: Text(
              "Terdaftar Resmi Oleh:",
              style: bodyTextStyle(context, fontSize: 14),
            ),
          ),
          const SizedBox(height: 18),

          // Carousel Manual 3 Gambar
          BlocBuilder<GallerymemberCariBloc, GallerymemberCariState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                return Text("Belum ada partner terdaftar",
                    style: bodyTextStyle(context));
              }

              final items = state.items.take(6).toList(); // ambil maksimal 6

              return SizedBox(
                height: isMobile ? 60 : 80,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // 🔧 jarak antar gambar
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double scale = 1.0;
                          if (_pageController.position.haveDimensions) {
                            scale = (_pageController.page! - index).abs();
                            scale = (1 - (scale * 0.3)).clamp(0.8, 1.0);
                          }
                          return Transform.scale(
                            scale: scale,
                            child: _ClientLogoCard(
                              imagePath: items[index].image1Url,
                              isMobile: isMobile,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 22),

          // Sosmed
          Text(
            "Ikuti perjalanan kami & temukan insight seputar asuransi:",
            textAlign: TextAlign.center,
            style: bodyTextStyle(context),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocmedIcon('assets/icons/instagram.svg', isMobile),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/tiktok.svg', isMobile),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/linkedin.svg', isMobile),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/facebook.svg', isMobile),
            ],
          ),
        ],
      ),
    );
  }
}

// Card Logo
class _ClientLogoCard extends StatelessWidget {
  final String imagePath;
  final bool isMobile;

  const _ClientLogoCard({required this.imagePath, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = isMobile ? 72 : 95;
    final double cardHeight = isMobile ? 42 : 60;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: Colors.white),
        color : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius - 1),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Icon(
            Icons.error,
            color: Colors.white,
            size: isMobile ? 18 : 32,
          ),
        ),
      ),
    );
  }
}

// Ikon Sosmed
Widget SocmedIcon(String assetPath, bool isMobile) => Container(
  width: isMobile ? 40 : 48,
  height: isMobile ? 40 : 48,
  padding: const EdgeInsets.all(1),
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: sGrey,
  ),
  child: Container(
    decoration: const BoxDecoration(
      color: pGrey,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: SvgPicture.asset(
        assetPath,
        width: isMobile ? 20 : 30,
        height: isMobile ? 20 : 30,
        colorFilter:
        const ColorFilter.mode(primaryLightColor, BlendMode.srcIn),
        allowDrawingOutsideViewBox: true,
        fit: BoxFit.scaleDown,
      ),
    ),
  ),
);