import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gallery/galleryeventcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'dart:math';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  late final PageController _pageController;
  int _currentIndex = 1; // kita mulai dari 1 (karena looping pakai dummy)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: _currentIndex,
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
      padding: const EdgeInsets.symmetric(vertical: vPadding),
      decoration: const BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildCarouselFromBloc(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: Text(
        'Yuk, mulai klaim sekarang!',
        style: headingStyle(context).copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildCarouselFromBloc() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ambil lebar parent
        final width = constraints.maxWidth;
        // atur rasio banner dinamis — misal 16:9 (bisa disesuaikan)
        final height = width * 0.45; // 16:7-ish, cocok buat banner landscape

        return SizedBox(
          height: height,
          child: BlocBuilder<GalleryeventCariBloc, GalleryeventCariState>(
            builder: (context, state) {
              if (state.status == ListStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }

              if (state.status == ListStatus.success && state.items.isNotEmpty) {
                final images = state.items;
                if (images.length < 2) {
                  return _buildCarouselItemFromNetwork(images.first.galleryUrl);
                }

                final loopedImages = [
                  images.last,
                  ...images,
                  images.first,
                ];

                return PageView.builder(
                  controller: _pageController,
                  itemCount: loopedImages.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                    if (index == 0) {
                      _pageController.jumpToPage(loopedImages.length - 2);
                    } else if (index == loopedImages.length - 1) {
                      _pageController.jumpToPage(1);
                    }
                  },
                  itemBuilder: (context, index) {
                    final item = loopedImages[index];

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          final diff = _pageController.page! - index;
                          value = (1 - (diff.abs() * 0.25)).clamp(0.9, 1.0);
                        } else {
                          value = (index == _currentIndex) ? 1.0 : 0.9;
                        }

                        return Center(
                          child: Transform.scale(
                            scale: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: _buildCarouselItemFromNetwork(item.galleryUrl),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              if (state.status == ListStatus.success && state.items.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada gambar event 😢",
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.6),
                      fontSize: getResponsiveFont(context, 16),
                    ),
                  ),
                );
              }

              return const Center(
                child: Text("Terjadi kesalahan saat memuat gambar"),
              );
            },
          ),
        );
      },
    );

  }

  Widget _buildCarouselItemFromNetwork(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade900,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
          );
        },
      ),
    );
  }
}
