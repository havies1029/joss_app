import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class ListMenuWidget extends StatelessWidget {
  const ListMenuWidget({super.key});

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
          // Header dengan "Lihat Semua"
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 22),
                  color: primaryLightColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20), // ⬅️ kasih jarak kanan
                child: SvgPicture.asset(
                  'assets/icons/settings-2.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    primaryLightColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: hPadding),

          // Horizontal Scrollable Menu Items
          _buildHorizontalMenu(context),
        ],
      ),
    );
  }

  Widget _buildHorizontalMenu(BuildContext context) {
    final menuItems = _getMenuItems();
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = _getItemWidth(screenWidth);

    return SizedBox(
      height: _getMenuHeight(),
      child: Stack(
        children: [
          // 👉 Scrollable list menu tanpa padding & separator
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return SizedBox(
                width: itemWidth,
                child: _buildMenuItem(context, item),
              );
            },
          ),

          // 👉 Gradient kiri (gelap → transparan)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 48,
            child: Container(
              decoration: const BoxDecoration(
                gradient: blackFadeGradientHorizontal,
              ),
            ),
          ),

          // 👉 Gradient kanan (transparan → gelap)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 48,
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



  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return GestureDetector(
      onTap: () {
        debugPrint('${item.title} tapped');
        // TODO: Navigate to respective page
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container - Diperbesar
          Stack(
            children: [
              Container(
                width: 70, // Diperbesar dari 60
                height: 70, // Diperbesar dari 60
                decoration: BoxDecoration(
                  color: secondaryBlackColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: sGrey.withOpacity(0.3),
                    width: 1.5,
                  ),
                  // Tambahkan shadow untuk efek depth
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    item.iconPath,
                    width: 40, // Diperbesar dari 32
                    height: 40, // Diperbesar dari 32
                  ),
                ),
              ),

              // Popular badge
              if (item.isPopular)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: orangeSmoothGradientHorizontal,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Populer!',
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 9),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: getResponsiveFont(context, 16), // Sedikit diperbesar
                      color: primaryLightColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Subtitle
                  if (item.subtitle.isNotEmpty) ...[
                    // const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 16),
                        color: primaryLightColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menentukan lebar item berdasarkan ukuran layar
  double _getItemWidth(double screenWidth) {
    if (screenWidth > 600) return 120; // Tablet/Desktop
    if (screenWidth > 400) return 100; // Large phone
    return 85; // Small phone
  }

  // Menentukan tinggi menu container
  double _getMenuHeight() {
    return 140; // Tinggi total untuk menampung icon yang lebih besar
  }

  // Responsive cross axis count untuk menentukan kapan harus scroll
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 5; // Tablet/Desktop
    if (width > 400) return 4; // Large phone
    return 3; // Small phone
  }

  // Menu items data
  List<MenuItem> _getMenuItems() {
    return [
      MenuItem(
        title: 'Cari',
        subtitle: 'Asuransi',
        iconPath: 'assets/icons/cari-asuransi-1.svg',
        isPopular: true,
      ),
      MenuItem(
        title: 'Lapor',
        subtitle: 'Klaim',
        iconPath: 'assets/icons/lapor-klaim-2.svg',
      ),
      MenuItem(
        title: 'Aset',
        subtitle: '',
        iconPath: 'assets/icons/aset-3.svg',
      ),
      MenuItem(
        title: 'Polis',
        subtitle: '',
        iconPath: 'assets/icons/polis-4.svg',
      ),
      MenuItem(
        title: 'Beli',
        subtitle: 'Polis',
        iconPath: 'assets/icons/beli-polis-5.svg',
      ),
      // Tambahkan item lain jika diperlukan untuk testing scroll
      MenuItem(
        title: 'Klaim',
        subtitle: '',
        iconPath: 'assets/icons/klaim-6.svg',
      ),
      MenuItem(
        title: 'Tagihan',
        subtitle: 'Pembayaran',
        iconPath: 'assets/icons/tagihan-pembayaran-7.svg',
      ),
    ];
  }
}

// Data model untuk menu item
class MenuItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isPopular;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.isPopular = false,
  });
}