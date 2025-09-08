import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/gen_review/reviewcari_bloc.dart';
import '../models/gen_review/reviewcari_model.dart';

class TestimonialSection extends StatefulWidget {
  final bool isPageMode; // Parameter untuk menentukan mode tampilan

  const TestimonialSection({
    super.key,
    this.isPageMode = false, // Default sebagai widget mode
  });

  @override
  State<TestimonialSection> createState() => TestimonialSectionState();
}

class TestimonialSectionState extends State<TestimonialSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _displayedItems = 10; // Jumlah items yang ditampilkan di page mode

  @override
  void initState() {
    super.initState();
    context.read<ReviewCariBloc>().add(RefreshReviewCariEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadMoreItems(int totalItems) {
    setState(() {
      _displayedItems =
      (_displayedItems + 10 > totalItems) ? totalItems : _displayedItems + 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width;
    final bool isMobile = maxWidth < 768;
    final bool isTablet = maxWidth >= 768 && maxWidth < 1024;
    final double cardMaxWidth = maxWidth > 1200 ? 1200 : maxWidth * 0.9;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: maxWidth > 1200 ? 105 : 20.0),
      child: Center(
        child: Container(
          width: cardMaxWidth,
          child: BlocBuilder<ReviewCariBloc, ReviewCariState>(
            builder: (context, state) {
              if (state.status == ListStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == ListStatus.failure) {
                return const Center(child: Text('Failed to load testimonials'));
              } else if (state.items.isEmpty) {
                return const Center(child: Text('No testimonials available'));
              }

              final items = state.items;

              return widget.isPageMode
                  ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(isMobile),
                    const SizedBox(height: 16),
                    _buildGridView(items, isMobile, isTablet),
                    SizedBox(height: 20.0),
                    if (_displayedItems < items.length)
                      _buildLoadMoreButton(items.length),
                  ],
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 16),
                  _buildCarouselView(items, isMobile, isTablet),
                  SizedBox(height: isMobile ? 10.0 : 15.0),
                  _buildNavigationControls(isMobile, isTablet, items),
                ],
              );

            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/quote.svg', height: 24),
            const SizedBox(width: 6),
            Text(
              "Apa Kata Klien Kami",
              style: bodyTextStyle(context, fontSize: 22),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          "Kata mereka yang sudah merasakan layanan JPS.",
          style: bodyTextStyle(context).copyWith(color: hintGrey),
        ),
      ],
    );
  }

  // Grid view untuk page mode
  Widget _buildGridView(List<ReviewCariModel> items, bool isMobile, bool isTablet) {
    final itemsToShow = items.take(_displayedItems).toList();
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 1.7 : 1.6,
      ),
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        return _buildTestimonialCard(itemsToShow[index], isMobile);
      },
    );
  }

  // Carousel view untuk widget mode
  Widget _buildCarouselView(List<ReviewCariModel> items, bool isMobile, bool isTablet) {
    return _buildTestimonialCards(items, isMobile, isTablet);
  }

  Widget _buildStarRating(double rating, double size) {
    int fullStars = rating.floor();
    double decimal = rating - fullStars;

    bool hasHalfStar = decimal >= 0.25 && decimal < 0.75;
    bool shouldRoundUp = decimal >= 0.75;

    if (shouldRoundUp) {
      fullStars += 1;
      hasHalfStar = false;
    }

    int totalStars = fullStars + (hasHalfStar ? 1 : 0);
    int emptyStars = 5 - totalStars;

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: pYellow, size: size),
        if (hasHalfStar) Icon(Icons.star_half, color: pYellow, size: size),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: pYellow, size: size),
      ],
    );
  }

  Widget _buildTestimonialCards(
      List<ReviewCariModel> items,
      bool isMobile,
      bool isTablet,
      ) {
    final int itemsPerPage = isMobile ? 1 : (isTablet ? 2 : 3);
    final totalPages = (items.length / itemsPerPage).ceil();

    return SizedBox(
      height: isMobile ? 210.37 : 210.37,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) => setState(() => _currentPage = page),
        itemCount: totalPages,
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * itemsPerPage;
          final endIndex =
          (startIndex + itemsPerPage > items.length)
              ? items.length
              : startIndex + itemsPerPage;

          return Row(
            children: [
              for (int i = startIndex; i < endIndex; i++) ...[
                Expanded(child: _buildTestimonialCard(items[i], isMobile)),
                if (i < endIndex - 1) const SizedBox(width: 16),
              ],
              // Add empty spaces for incomplete rows to maintain layout
              if (endIndex - startIndex < itemsPerPage)
                ...List.generate(
                  itemsPerPage - (endIndex - startIndex),
                      (_) => const Expanded(child: SizedBox()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTestimonialCard(ReviewCariModel item, bool isMobile) {
    return Container(
      margin: widget.isPageMode ? EdgeInsets.zero : const EdgeInsets.only(right: hPadding),
      padding: const EdgeInsets.only(right: 25, left: 25, top: 20, bottom: 35),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating + stars row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 20.37,
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                decoration: BoxDecoration(
                  color: pYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.nilai.toStringAsFixed(1),
                        style: const TextStyle(color: pYellow, fontSize: 14),
                      ),
                      Text(
                        ' /${item.skala.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: primaryLightColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              _buildStarRating(item.nilai, 18),
            ],
          ),
          const SizedBox(height: 15),
          // Nama + subtitle + testimonial badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nama & role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.reviewer,
                      style: bodyTextStyle(context, fontSize: 20),
                    ),
                    Text(
                      item.instansi,
                      style: bodyTextStyle(
                        context,
                        fontSize: 16,
                      ).copyWith(color: hintGrey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/thumbsup_solid.svg',
                    width: 16.66,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Testimonial',
                    style: bodyTextStyle(context, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Quote testimonial
          Expanded(
            child: Text('"${item.komentar}"', style: bodyTextStyle(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(
      bool isMobile,
      bool isTablet,
      List<ReviewCariModel> items,
      ) {
    if (items.isEmpty) return const SizedBox.shrink();

    final int itemsPerPage = isMobile ? 1 : (isTablet ? 2 : 3);
    final totalPages = (items.length / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed:
          _currentPage > 0
              ? () => _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
            minimumSize: Size(isMobile ? 36 : 40, isMobile ? 36 : 40),
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset('assets/icons/arrow_left.svg', height: 16),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed:
          _currentPage < totalPages - 1
              ? () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
            minimumSize: Size(isMobile ? 36 : 40, isMobile ? 36 : 40),
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset('assets/icons/arrow_right.svg', height: 16),
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton(int totalItems) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: () => _loadMoreItems(totalItems),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Lihat Lebih Banyak',
          style: bodyTextStyle(context, fontSize: 16).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
