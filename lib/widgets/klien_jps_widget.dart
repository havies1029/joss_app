import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import '../blocs/gallery/gallerymembercari_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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

  int _lastAutoSlideLength = 0;

  void _ensureAutoSlide(int length) {
    if (length <= 1) {
      _autoSlideTimer?.cancel();
      _autoSlideTimer = null;
      return;
    }

    if (_autoSlideTimer != null && _lastAutoSlideLength == length) return;

    _autoSlideTimer?.cancel();
    _lastAutoSlideLength = length;

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % length;
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
                "Didukung oleh Mitra Kami",
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
              "Bekerja Sama Dengan:",
              style: bodyTextStyle(context, fontSize: 14),
            ),
          ),
          const SizedBox(height: 18),

          // Carousel Manual 3 Gambar
          BlocBuilder<GallerymemberCariBloc, GallerymemberCariState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                _autoSlideTimer?.cancel(); // stop timer kalau kosong
                return Text("Belum ada partner terdaftar", style: bodyTextStyle(context));
              }

              final items = state.items.take(6).toList();
              _ensureAutoSlide(items.length); // start/refresh timer sesuai jumlah item

              return SizedBox(
                height: isMobile ? 60 : 80,
                child: PageView.builder(
                  key: const PageStorageKey('client_logo_carousel'),
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          final currentPage = _pageController.page ??
                              _pageController.initialPage.toDouble();

                          final diff = (currentPage - index).abs();
                          final scale = (1 - (diff * 0.3)).clamp(0.8, 1.0);

                          return Transform.scale(scale: scale, child: child);
                        },
                        child: _ClientLogoPageItem(
                          imageUrl: items[index].image1Url,
                          isMobile: isMobile,
                        ),
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
            "Didukung mitra finansial untuk pengalaman asuransi yang lebih mudah.",
            textAlign: TextAlign.center,
            style: bodyTextStyle(context),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocmedIcon('assets/icons/instagram.svg', isMobile, url: 'https://www.instagram.com/jayaproteksindosakti?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=='),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/website_logo.svg', isMobile, url: 'https://jayaproteksindo.co.id/'),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/linkedin.svg', isMobile, url: 'https://www.linkedin.com/company/jayaproteksindo/'),
              const SizedBox(width: 20),
              SocmedIcon('assets/icons/facebook.svg', isMobile, url: 'https://www.facebook.com/people/PT-Jaya-Proteksindo-Sakti/100054470620648/'),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius - 1),
        child: Container(
          color: const Color(0xFFFEFEFE),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.contain,
            memCacheWidth: (cardWidth * 2).toInt(),
            placeholder: (_, __) => const SizedBox.shrink(),
            errorWidget: (_, __, ___) => Icon(
              Icons.error,
              color: Colors.black54,
              size: isMobile ? 18 : 32,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Tidak bisa membuka $url';
  }
}

Future<void> _launchLink(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Widget SocmedIcon(String assetPath, bool isMobile, {required String url}) => Material(
  color: Colors.transparent,
  shape: const CircleBorder(),
  child: InkWell(
    onTap: () => openUrl(url), // atau _launchLink(url)
    customBorder: const CircleBorder(),
    child: Container(
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
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFFFFF),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    ),
  ),
);

class _ClientLogoPageItem extends StatefulWidget {
  final String imageUrl;
  final bool isMobile;

  const _ClientLogoPageItem({
    required this.imageUrl,
    required this.isMobile,
  });

  @override
  State<_ClientLogoPageItem> createState() => _ClientLogoPageItemState();
}

class _ClientLogoPageItemState extends State<_ClientLogoPageItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary( // bantu isolasi repaint saat animasi scale
      child: _ClientLogoCard(
        imagePath: widget.imageUrl,
        isMobile: widget.isMobile,
      ),
    );
  }
}