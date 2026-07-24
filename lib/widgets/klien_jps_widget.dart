import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/gallery/gallerymembercari_bloc.dart';
import '../blocs/logoclient/mlogoclientcari_bloc.dart';
import '../common/loading_indicator.dart';

class ClientSection extends StatefulWidget {
  const ClientSection({super.key});

  @override
  State<ClientSection> createState() => _ClientSectionState();
}

class _ClientSectionState extends State<ClientSection> {
  static const Duration _autoSlideInterval = Duration(seconds: 3);
  static const Duration _slideDuration = Duration(milliseconds: 600);

  late final PageController _pageController;

  Timer? _autoSlideTimer;
  int _currentPage = 0;
  int _lastAutoSlideLength = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.24);

    context.read<GallerymemberCariBloc>().add(
      RefreshGallerymemberCariEvent(),
    );

    context.read<MlogoclientCariBloc>().add(
      FetchMlogoclientCariEvent(),
    );
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _ensureAutoSlide(int length) {
    if (length <= 1) {
      _stopAutoSlide();
      return;
    }

    if (_autoSlideTimer != null && _lastAutoSlideLength == length) return;

    _stopAutoSlide();
    _lastAutoSlideLength = length;

    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % length;

      _pageController.animateToPage(
        nextPage,
        duration: _slideDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
    _lastAutoSlideLength = 0;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(context),
          const SizedBox(height: 6),
          _buildBadge(context),
          const SizedBox(height: 18),
          _buildLogoCarousel(context, isMobile),
          const SizedBox(height: 22),
          _buildDescription(context),
          const SizedBox(height: 12),
          _buildSocmedRow(isMobile),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/badge.svg', height: 24),
        const SizedBox(width: 6),
        Text(
          'Didukung oleh Mitra Kami',
          style: bodyTextStyle(context, fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Text(
        'Bekerja Sama Dengan:',
        style: bodyTextStyle(context, fontSize: 14),
      ),
    );
  }

  Widget _buildLogoCarousel(BuildContext context, bool isMobile) {
    return BlocBuilder<GallerymemberCariBloc, GallerymemberCariState>(
      buildWhen: (prev, curr) {
        return prev.items != curr.items || prev.status != curr.status;
      },
      builder: (context, state) {
        if (state.items.isEmpty) {
          _stopAutoSlide();

          return Text(
            'Belum ada partner terdaftar',
            style: bodyTextStyle(context),
          );
        }

        final items = state.items.take(6).toList();

        _ensureAutoSlide(items.length);

        return SizedBox(
          height: isMobile ? 60 : 80,
          child: PageView.builder(
            key: const PageStorageKey('client_logo_carousel'),
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            onPageChanged: (index) {
              if (_currentPage == index) return;

              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedBuilder(
                  animation: _pageController,
                  child: _ClientLogoPageItem(
                    imageUrl: item.image1Url,
                    isMobile: isMobile,
                  ),
                  builder: (context, child) {
                    double scale = 1.0;

                    if (_pageController.hasClients &&
                        _pageController.position.haveDimensions) {
                      final currentPage =
                          _pageController.page ??
                              _pageController.initialPage.toDouble();

                      final diff = (currentPage - index).abs();
                      scale = (1 - (diff * 0.3)).clamp(0.8, 1.0);
                    }

                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Didukung mitra finansial untuk pengalaman asuransi yang lebih mudah.',
      textAlign: TextAlign.center,
      style: bodyTextStyle(context),
    );
  }

  Widget _buildSocmedRow(bool isMobile) {
    return BlocBuilder<
        MlogoclientCariBloc,
        MlogoclientCariState>(
      builder: (context, state) {

        if (state.status == ListStatus.loadingMore) {
          return const SizedBox.shrink();
        }

        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 12,
          children: state.items.map((item) {
            return SocmedIcon(
              'assets/icons/${item.logoSvg}',
              isMobile,
              url: item.linkUrl,
            );
          }).toList(),
        );
      },
    );
  }
}

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

    return RepaintBoundary(
      child: _ClientLogoCard(
        imagePath: widget.imageUrl,
        isMobile: widget.isMobile,
      ),
    );
  }
}

class _ClientLogoCard extends StatelessWidget {
  final String imagePath;
  final bool isMobile;

  const _ClientLogoCard({
    required this.imagePath,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = isMobile ? 76.0 : 95.0;
    final cardHeight = isMobile ? 46.0 : 60.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.contain,
          memCacheWidth: (cardWidth * 3).toInt(),
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (_, __) => const Center(
            child: LoadingIndicator(),
          ),
          errorWidget: (_, __, ___) {
            return Icon(
              Icons.error,
              color: Colors.white54,
              size: isMobile ? 18 : 32,
            );
          },
        ),
      ),
    );
  }
}

Widget SocmedIcon(
    String assetPath,
    bool isMobile, {
      required String url,
    }) {
  return Material(
    color: Colors.transparent,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: () => openUrl(url),
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
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);

  final canOpen = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!canOpen) {
    throw 'Tidak bisa membuka $url';
  }
}
