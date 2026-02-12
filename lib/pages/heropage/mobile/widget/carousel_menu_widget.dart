import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joss_app/blocs/gallery/galleryeventcari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../common/loading_indicator.dart';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  late final PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.82,
      initialPage: _currentIndex,
      keepPage: true,
    );

    context.read<GalleryeventCariBloc>().add(RefreshGalleryeventCariEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        'Yuk, mulai klaim sekarang!',
        style: headingStyle(context).copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildCarouselFromBloc(BuildContext context) {
    return BlocBuilder<GalleryeventCariBloc, GalleryeventCariState>(
      buildWhen: (prev, curr) => prev.items != curr.items || prev.status != curr.status,
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: LoadingIndicator(),
            ),
          );
        }


        if (state.status == ListStatus.success && state.items.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada gambar event",
              style: TextStyle(
                color: primaryLightColor.withOpacity(0.6),
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
          );
        }

        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          final images = state.items;
          final loopedImages = [images.last, ...images, images.first];
          return _buildCarousel(loopedImages);
        }

        return const Center(
          child: Text("Terjadi kesalahan saat memuat gambar"),
        );
      },
    );
  }

  Widget _buildCarousel(List images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 0.38;
        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              final lastIndex = images.length - 1;

              if (index == 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pageController.jumpToPage(images.length - 2);
                });
                return;
              }

              if (index == lastIndex) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pageController.jumpToPage(1);
                });
                return;
              }

              setState(() => _currentIndex = index);
            },

            itemBuilder: (context, index) {
              final item = images[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    final diff = _pageController.page! - index;
                    scale = (1 - (diff.abs() * 0.25)).clamp(0.9, 1.0);
                  }
                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCachedImage(item.galleryUrl),
                ),
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
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

}