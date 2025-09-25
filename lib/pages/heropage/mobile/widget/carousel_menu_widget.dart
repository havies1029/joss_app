import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  final PageController _pageController = PageController(
    viewportFraction: 0.78,
    initialPage: 0,
  );
  int _currentIndex = 0;

  final List<String> _localImages = [
    "assets/images/sample1.png",
    "assets/images/sample2.png",
    "assets/images/sample3.png",
  ];

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
        children: [
          _buildHeader(),
          _buildCarousel(context),
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

  Widget _buildCarousel(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _localImages.length,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = _localImages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _buildCarouselItemFromAsset(item),
          );
        },
      ),
    );
  }

  Widget _buildCarouselItemFromAsset(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        assetPath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
