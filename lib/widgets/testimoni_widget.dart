import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/gen_review/reviewcari_bloc.dart';
import '../models/gen_review/reviewcari_model.dart';

class TestimonialSection extends StatefulWidget {
  final bool isPageMode;
  const TestimonialSection({
    super.key,
    this.isPageMode = false,
  });

  @override
  State<TestimonialSection> createState() => TestimonialSectionState();
}

class TestimonialSectionState extends State<TestimonialSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _displayedItems = 10;

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
    return Container(
      color: secondaryBlackColor,
      width: double.infinity,
      padding: widget.isPageMode ? EdgeInsets.all(15) : EdgeInsets.all(0),
      child: Center(
        child: Container(
          width: 360,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildGridView(context, items),
                    if (_displayedItems < items.length)
                      _buildLoadMoreButton(items.length),
                  ],
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildCarouselView(context, items),
                  SizedBox(height: isMobile(context) ? 10.0 : 15.0),
                  _buildNavigationControls(context, items),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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

  /// Grid view untuk page mode
  Widget _buildGridView(BuildContext context, List<ReviewCariModel> items) {
    final mobile = isMobile(context);
    final tablet = isTablet(context);

    final itemsToShow = items.take(_displayedItems).toList();
    final int crossAxisCount = mobile ? 1 : (tablet ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: mobile ? 1.7 : 1.6,
      ),
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        return _buildTestimonialCard(context, itemsToShow[index]);
      },
    );
  }

  /// Carousel view untuk widget mode
  Widget _buildCarouselView(BuildContext context, List<ReviewCariModel> items) {
    return _buildTestimonialCards(context, items);
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

  Widget _buildTestimonialCards(BuildContext context, List<ReviewCariModel> items) {
    final mobile = isMobile(context);
    final tablet = isTablet(context);

    final int itemsPerPage = mobile ? 1 : (tablet ? 2 : 3);
    final totalPages = (items.length / itemsPerPage).ceil();

    return SizedBox(
      height: 210.37,
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
                Expanded(child: _buildTestimonialCard(context, items[i])),
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

  Widget _buildTestimonialCard(BuildContext context, ReviewCariModel item) {
    return Container(
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
                          color: hintGrey,
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

  Widget _buildNavigationControls(BuildContext context, List<ReviewCariModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    final mobile = isMobile(context);
    final tablet = isTablet(context);

    final int itemsPerPage = mobile ? 1 : (tablet ? 2 : 3);
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
            minimumSize: Size(mobile ? 36 : 40, mobile ? 36 : 40),
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
            minimumSize: Size(mobile ? 36 : 40, mobile ? 36 : 40),
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