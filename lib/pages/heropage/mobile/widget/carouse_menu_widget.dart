import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'dart:math';

class CarouselMenuWidget extends StatefulWidget {
  const CarouselMenuWidget({super.key});

  @override
  State<CarouselMenuWidget> createState() => _CarouselMenuWidgetState();
}

class _CarouselMenuWidgetState extends State<CarouselMenuWidget> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  List<CarouselItem> _carouselItems = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _carouselItems = _getCarouselItems();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(hPadding),
      decoration: BoxDecoration(
        color: secondaryBlackColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan navigasi
          _buildHeader(),
          const SizedBox(height: hPadding),

          // Carousel content
          _buildCarousel(context),

          const SizedBox(height: 16),

          // Dots indicator
          _buildDotsIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Yuk, mulai klaim sekarang!',
      style: TextStyle(
        fontSize: getResponsiveFont(context, 18),
        color: primaryLightColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Container(
      height: _getCarouselHeight(),
      child: Stack(
        children: [
          // PageView untuk carousel dengan infinite scroll
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index % _carouselItems.length;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = index % _carouselItems.length;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildCarouselItem(context, _carouselItems[actualIndex]),
              );
            },
          ),

          // Gradient fade kiri
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 20,
            child: Container(
              decoration: const BoxDecoration(
                gradient: blackFadeGradientHorizontal,
              ),
            ),
          ),

          // Gradient fade kanan
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 20,
            child: Container(
              decoration: const BoxDecoration(
                gradient: blackFadeGradientHorizontalReversed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, CarouselItem item) {
    return GestureDetector(
      onTap: () {
        debugPrint('${item.title} carousel tapped');
        // TODO: Navigate to respective page
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: item.backgroundGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Left content
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Company logo
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo placeholder
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: item.logoColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    item.logoText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.companyName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Main text
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.badgeColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.badgeText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveFont(context, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Description
                        Text(
                          item.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFont(context, 14),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Payment methods
                        Row(
                          children: [
                            Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ...item.paymentMethods.map((method) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  method,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )).take(2),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right content - Phone mockup
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Phone frame
                          Container(
                            width: 80,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Notch
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 30,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                                // Screen content
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: item.phoneScreenColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Claim button
                                        Positioned(
                                          right: 8,
                                          top: 20,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: item.claimButtonColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Claim',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Hand gesture
                                        Positioned(
                                          bottom: 15,
                                          right: 15,
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.touch_app,
                                              size: 16,
                                              color: item.claimButtonColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_carouselItems.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? primaryLightColor
                : sGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  void _nextPage() {
    // Function removed - users can swipe directly on carousel
  }

  void _previousPage() {
    // Function removed - users can swipe directly on carousel
  }

  double _getCarouselHeight() {
    return 160.0;
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.lime,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  List<CarouselItem> _getCarouselItems() {
    return List.generate(5, (index) {
      final randomColor = _getRandomColor();
      final randomColor2 = _getRandomColor();

      return CarouselItem(
        title: 'Item ${index + 1}',
        companyName: 'Company ${index + 1}',
        logoText: 'C${index + 1}',
        logoColor: randomColor,
        badgeText: 'Badge ${index + 1}',
        badgeColor: randomColor2,
        description: 'Description for item ${index + 1}',
        backgroundGradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        phoneScreenColor: Colors.orange.shade100,
        claimButtonColor: randomColor,
        paymentMethods: ['PAY${index + 1}', 'BANK${index + 1}'],
      );
    });
  }
}

// Data model untuk carousel item
class CarouselItem {
  final String title;
  final String companyName;
  final String logoText;
  final Color logoColor;
  final String badgeText;
  final Color badgeColor;
  final String description;
  final LinearGradient backgroundGradient;
  final Color phoneScreenColor;
  final Color claimButtonColor;
  final List<String> paymentMethods;

  CarouselItem({
    required this.title,
    required this.companyName,
    required this.logoText,
    required this.logoColor,
    required this.badgeText,
    required this.badgeColor,
    required this.description,
    required this.backgroundGradient,
    required this.phoneScreenColor,
    required this.claimButtonColor,
    required this.paymentMethods,
  });
}