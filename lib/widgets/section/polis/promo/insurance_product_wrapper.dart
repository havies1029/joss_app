import 'package:flutter/material.dart';
import 'package:joss_app/models/gen_promo/promo1cari_model.dart';
import 'package:joss_app/models/gen_promo/promo2cari_model.dart';
import 'package:joss_app/repositories/gen_promo/promo2cari_repository.dart';
import 'package:flutter_svg/svg.dart';

class InsuranceProductWrapper extends StatelessWidget {
  final List<Promo1CariModel> promo1List;

  const InsuranceProductWrapper({super.key, required this.promo1List});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beli Polis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 100),
          const Text(
            'Pilih produk asuransi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),

          // Bagian Grid Card
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: promo1List.map((promo1) {
              final screenWidth = MediaQuery.of(context).size.width;
              final bool isMobile = screenWidth < 600;
              final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

              final double cardWidth = screenWidth >= 1024
                  ? (screenWidth - 96) / 3
                  : screenWidth >= 600
                  ? (screenWidth - 80) / 2
                  : screenWidth - 48;

              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile || isTablet ? 4 : 0, // ✅ Tambah space atas bawah untuk mobile & tablet
                ),
                child: SizedBox(
                  width: cardWidth,
                  child: InsuranceProductCard(promo1: promo1),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kembali ditekan')),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF91C050),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lanjutkan ditekan')),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Lanjutkan'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InsuranceProductCard extends StatelessWidget {
  final Promo1CariModel promo1;

  const InsuranceProductCard({super.key, required this.promo1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1024;
        final bool isDesktop = width >= 1024;

        final TextStyle headingStyle = TextStyle(
          fontFamily: 'Satoshi-Regular',
          fontSize: isMobile ? 18 : isTablet ? 19 : 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

        final TextStyle labelStyle = TextStyle(
          fontFamily: 'Satoshi-Regular',
          fontSize: isMobile ? 13 : 14,
          color: Colors.black54,
        );

        final TextStyle hargaStyle = TextStyle(
          fontFamily: 'Satoshi-Regular',
          color: const Color(0xFF91C050),
          fontSize: isMobile ? 24 : isTablet ? 26 : 30,
          fontWeight: FontWeight.bold,
        );

        final TextStyle satuanStyle = TextStyle(
          fontFamily: 'Satoshi-Regular',
          fontSize: isMobile ? 12 : 14,
          color: Colors.black54,
        );

        final TextStyle fiturTextStyle = TextStyle(
          fontFamily: 'Satoshi-Regular',
          fontSize: isMobile ? 13 : 15,
          color: Colors.black,
        );

        final double iconSize = isMobile ? 18 : 24;
        final double badgeFontSize = isMobile ? 11 : 13;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 19,
                  vertical: isMobile ? 20 : 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promo1.cobNama, style: headingStyle),
                    const SizedBox(height: 12),
                    Text("Mulai dari", style: labelStyle),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${promo1.curr} ${promo1.hargaStart.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                          )}",
                          style: hargaStyle,
                        ),
                        const SizedBox(width: 4),
                        Baseline(
                          baseline: isMobile ? 16 : 18,
                          baselineType: TextBaseline.alphabetic,
                          child: Text("/${promo1.hargaSatuan}", style: satuanStyle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(promo1.ringkasan, style: labelStyle),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Promo2CariModel>>(
                      future: _loadPromo2Data(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF91C050)),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Error loading features: ${snapshot.error}",
                              style: TextStyle(
                                fontFamily: 'Satoshi-Regular',
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        final fiturList = snapshot.data ?? [];

                        if (fiturList.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Tidak ada fitur tersedia",
                              style: TextStyle(
                                fontFamily: 'Satoshi-Regular',
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: fiturList.map((fitur) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/check.svg',
                                    width: iconSize,
                                    height: iconSize,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF91C050),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      fitur.fitur,
                                      style: fiturTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (promo1.isPopular ?? false)
              Positioned(
                top: -15,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF91C050),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Paling Populer',
                    style: TextStyle(
                      fontFamily: 'Satoshi-Regular',
                      color: Colors.white,
                      fontSize: badgeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<List<Promo2CariModel>> _loadPromo2Data() async {
    final repo = Promo2CariRepository();
    try {
      final items = await repo.getPromo2Cari(promo1.promo1Id, 0);
      items.sort((a, b) => a.noUrut.compareTo(b.noUrut));
      return items;
    } catch (e) {
      print('Error loading promo2 data: $e');
      return [];
    }
  }
}