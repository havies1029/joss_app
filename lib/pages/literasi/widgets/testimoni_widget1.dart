import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/loading_indicator.dart';

import '../../../blocs/gen_review/reviewcari_bloc.dart';
import '../../../models/gen_review/reviewcari_model.dart';

class TestimonialWidget1 extends StatefulWidget {
  final bool isPageMode;
  const TestimonialWidget1({
    super.key,
    this.isPageMode = false,
  });

  @override
  State<TestimonialWidget1> createState() => TestimonialWidget1State();
}

class TestimonialWidget1State extends State<TestimonialWidget1> {
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
      // padding: widget.isPageMode ? EdgeInsets.all(15) : EdgeInsets.all(0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 360,
          child: BlocBuilder<ReviewCariBloc, ReviewCariState>(
            builder: (context, state) {

              if (state.status == ListStatus.initial) {
                return const Center(child: LoadingIndicator());
              } else if (state.status == ListStatus.failure) {
                return Center(child: _emptyReviewWidget(context));
              } else if (state.items.isEmpty) {
                return Center(child: _emptyReviewWidget(context));
              }

              final items = state.items;
              //
              // final items =
              // state.items.isEmpty ? DummyReviewData.items : state.items;

              return widget.isPageMode
                  ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
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

  Widget _buildGridView(BuildContext context, List<ReviewCariModel> items) {
    final mobile = isMobile(context);
    final tablet = isTablet(context);

    final itemsToShow = items.take(_displayedItems).toList();
    final int crossAxisCount = mobile ? 1 : (tablet ? 2 : 3);

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
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
      ),
    );

  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    Text(
                      "${formatTanggalIndonesia(item.reviewTgl)} ·",
                      style: bodyTextStyle(context, fontSize: 16)
                          .copyWith(color: hintGrey),
                    ),
                    Text(
                      formatJam(item.reviewTgl),
                      style: bodyTextStyle(context, fontSize: 16)
                          .copyWith(color: hintGrey),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

  String formatTanggalIndonesia(DateTime dt) {
    const bulan = [
      '',
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Agu','Sep','Okt','Nov','Des'
    ];

    return "${dt.day} ${bulan[dt.month]} ${dt.year}";
  }

  String formatJam(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Widget _buildNavigationControls(BuildContext context, List<ReviewCariModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    final mobile = isMobile(context);
    final tablet = isTablet(context);

    final int itemsPerPage = mobile ? 1 : (tablet ? 2 : 3);
    final totalPages = (items.length / itemsPerPage).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return pGrey;
        }
        return primaryColor;
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      elevation: MaterialStateProperty.all(0),
      minimumSize: MaterialStateProperty.all(
        Size(mobile ? 36 : 40, mobile ? 36 : 40),
      ),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 0
              ? () => _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
              : null,
          style: buttonStyle,
          child: SvgPicture.asset('assets/icons/arrow_left.svg', height: 16),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _currentPage < totalPages - 1
              ? () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
              : null,
          style: buttonStyle,
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

  Widget _emptyReviewWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/empty_review_page.svg',
          height: 50,
        ),
        const SizedBox(height: 20),

        Text(
          'Tidak ada Review tersedia',
          style: TextStyle(
            fontSize: getResponsiveFont(context, 16),
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Saat ini belum tersedia Review apa pun',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getResponsiveFont(context, 14),
              color: hintGrey,
            ),
          ),
        ),
      ],
    );
  }
}


class DummyReviewData {
  static List<ReviewCariModel> get items => [
    ReviewCariModel(
      reviewer: "Budi Santoso",
      instansi: "PT Nusantara Teknologi",
      komentar:
      "Pelayanan sangat cepat dan profesional. Tim JPS sangat membantu proses kami.",
      nilai: 4.5,
      skala: 5,
      reviewTgl: DateTime(2024, 6, 12, 14, 21), isAktif: false, review1Id: '',
    ),
    ReviewCariModel(
      reviewer: "Siti Rahma",
      instansi: "Universitas Indonesia",
      komentar:
      "Sistemnya sangat mudah digunakan dan supportnya responsif.",
      nilai: 4.8,
      skala: 5,
      reviewTgl: DateTime(2024, 6, 12, 14, 21), isAktif: false, review1Id: '',
    ),
    ReviewCariModel(
      reviewer: "Ahmad Fauzi",
      instansi: "PT Global Logistik",
      komentar:
      "Layanan yang diberikan sangat memuaskan dan terpercaya.",
      nilai: 4.3,
      skala: 5,
      reviewTgl: DateTime(2024, 5, 20, 9, 30), isAktif: false, review1Id: '',
    ),
    ReviewCariModel(
      reviewer: "Dewi Lestari",
      instansi: "Bank Mandiri",
      komentar:
      "Implementasi berjalan lancar dan tim sangat kooperatif.",
      nilai: 4.7,
      skala: 5,
      reviewTgl: DateTime(2024, 5, 20, 9, 30), isAktif: false, review1Id: '',
    ),
    ReviewCariModel(
      reviewer: "Rizky Pratama",
      instansi: "Startup Digital ID",
      komentar:
      "Pengalaman kerja sama yang sangat baik. Highly recommended.",
      nilai: 4.6,
      skala: 5,
      reviewTgl: DateTime(2024, 4, 10, 16, 45), isAktif: true, review1Id: '',
    ),
  ];
}