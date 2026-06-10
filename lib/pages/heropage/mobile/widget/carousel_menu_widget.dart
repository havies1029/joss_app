import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joss_app/blocs/gallery/galleryeventcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/loading_indicator.dart';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  static const int _kFakeCount = 100000;
  static const Duration _autoSlideInterval = Duration(seconds: 4);
  static const Duration _slideDuration = Duration(milliseconds: 450);

  late final PageController _pageController;

  Timer? _autoSlideTimer;

  int _currentRealIndex = 0;
  int? _lastItemLength;
  bool _hasSyncedInitialPage = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.82,
      initialPage: 0,
      keepPage: false,
    );

    context.read<GalleryeventCariBloc>().add(RefreshGalleryeventCariEvent());
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    if (url.trim().isEmpty) return;

    final uri = Uri.tryParse(url.trim());

    if (uri == null || !uri.hasScheme) {
      debugPrint('[CAROUSEL] invalid url: $url');
      return;
    }

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      debugPrint('[CAROUSEL] tidak bisa membuka url: $url');
    }
  }

  void _syncInitialPageIfNeeded(int itemLength) {
    if (itemLength <= 0) return;

    final isNewLength = _lastItemLength != itemLength;

    if (_hasSyncedInitialPage && !isNewLength && _pageController.hasClients) {
      debugPrint("[CAROUSEL] sync skipped");
      return;
    }

    final middlePage = _kFakeCount ~/ 2;
    final fixedInitialPage = middlePage - (middlePage % itemLength);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;

      _pageController.jumpToPage(fixedInitialPage);

      _hasSyncedInitialPage = true;
      _lastItemLength = itemLength;


      setState(() {
        _currentRealIndex = 0;
      });

      _startAutoSlide(itemLength);
    });
  }

  void _startAutoSlide(int itemLength) {
    _autoSlideTimer?.cancel();

    if (itemLength <= 1) {
      debugPrint("[CAROUSEL] autoSlide skipped because itemLength <= 1");
      return;
    }

    _autoSlideTimer = Timer.periodic(_autoSlideInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final currentPage =
          _pageController.page?.round() ?? _pageController.initialPage;
      _pageController.animateToPage(
        currentPage + 1,
        duration: _slideDuration,
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: vPadding * 0.7),
      decoration: const BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildCarouselFromBloc(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: Text(
        'Yuk mulai Asuransi Sekarang!',
        style: headingStyle(context).copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildCarouselFromBloc(BuildContext context) {
    return BlocBuilder<GalleryeventCariBloc, GalleryeventCariState>(
      buildWhen: (prev, curr) {
        return prev.items != curr.items || prev.status != curr.status;
      },
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          _stopAutoSlide();

          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: LoadingIndicator()),
          );
        }

        if (state.status == ListStatus.success && state.items.isEmpty) {
          _stopAutoSlide();

          return Center(
            child: Text(
              'Tidak ada gambar event',
              style: TextStyle(
                color: primaryLightColor.withOpacity(0.6),
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
          );
        }

        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          final images = state.items;

          _syncInitialPageIfNeeded(images.length);

          return Column(
            children: [
              _buildInfiniteCarousel(images),
              const SizedBox(height: 8),
              _buildIndicator(images.length),
            ],
          );
        }

        _stopAutoSlide();

        return Center(
          child: Text(
            'Terjadi kesalahan saat memuat gambar',
            style: TextStyle(
              color: primaryLightColor.withOpacity(0.7),
              fontSize: getResponsiveFont(context, 14),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfiniteCarousel(List images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 0.38;

        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _kFakeCount,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (pageIndex) {
              final realIndex = pageIndex % images.length;

              if (_currentRealIndex == realIndex) return;

              setState(() {
                _currentRealIndex = realIndex;
              });
            },
            itemBuilder: (context, pageIndex) {
              final realIndex = pageIndex % images.length;
              final item = images[realIndex];

              return AnimatedBuilder(
                animation: _pageController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openUrl(item.eventUrl),
                    child: _buildCachedImage(item.galleryUrl),
                  ),
                ),
                builder: (context, child) {
                  double scale = 1.0;

                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    final currentPage =
                        _pageController.page ?? _pageController.initialPage.toDouble();

                    final diff = currentPage - pageIndex;
                    scale = (1 - (diff.abs() * 0.25)).clamp(0.9, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCachedImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        filterQuality: FilterQuality.medium,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (_, __) {
          return Container(
            color: formGrey,
            alignment: Alignment.center,
            child: const LoadingIndicator(),
          );
        },
        errorWidget: (_, __, ___) {
          return Container(
            color: Colors.grey.withOpacity(0.25),
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image,
              color: primaryLightColor.withOpacity(0.6),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicator(int itemCount) {
    if (itemCount <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == _currentRealIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: isActive ? primaryLightColor : aGrey,
          ),
        );
      }),
    );
  }
}