import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gallery/galleryeventcari_bloc.dart';

import '../../../../models/gallery/galleryeventcari_model.dart';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  final PageController _pageController = PageController(
    viewportFraction: 0.78,
    initialPage: 1000,
  );
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: vPadding),
      decoration: BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), _buildCarousel(context)],
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

  Widget _buildCarousel(BuildContext context) {
    return Container(
      height: 180,
      child: BlocBuilder<GalleryeventCariBloc, GalleryeventCariState>(
        builder: (context, state) {
          if (state.status == ListStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ListStatus.failure) {
            return const Center(child: Text('Failed to load data'));
          } else if (state.items.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: null,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index % state.items.length;
              });
            },
            itemBuilder: (context, index) {
              final realIndex = index % state.items.length;
              final item = state.items[realIndex];
              return Transform.scale(
                scale: 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 10.0,
                  ),
                  child: _buildCarouselItemFromBloc(context, item),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCarouselItemFromBloc(
    BuildContext context,
    GalleryeventCariModel item,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child:
          item.galleryUrl.isNotEmpty
              ? Image.network(
                item.galleryUrl,
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 160,
                      height: 160,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
              )
              : Container(
                width: 160,
                height: 160,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey, size: 48),
              ),
    );
  }
}
