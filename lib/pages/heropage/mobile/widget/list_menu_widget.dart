import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class ListMenuWidget extends StatelessWidget {
  const ListMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: hPadding - 4),
      decoration: BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Lihat Semua',
                  style: bodyTextStyle(context).copyWith(fontSize: 20),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/settings-2.svg',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          _buildHorizontalMenu(context),
        ],
      ),
    );
  }

  Widget _buildHorizontalMenu(BuildContext context) {
    final menuItems = _getMenuItems();
    final itemWidth = getItemWidth(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
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
            // Gradient kiri (gelap → transparan)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 40,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: blackFadeGradientHorizontal,
                ),
              ),
            ),
            // Gradient kanan (transparan → gelap)
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
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return GestureDetector(
      onTap: () {
        debugPrint('${item.title} tapped');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            margin: const EdgeInsets.only(top: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: pGrey,
                    shape: BoxShape.circle,
                    border: Border.all(color: sGrey),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      item.iconPath,
                      width: 38,
                      height: 38,
                    ),
                  ),
                ),

                if (item.isPopular)
                  Positioned(
                    top: -10,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                        gradient: orangeSmoothGradientHorizontal,
                      ),
                      child: Text(
                        'Populer!',
                        style: bodyTextStyle(
                          context,
                        ).copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          // Title
          Expanded(
            child: Column(
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodyTextStyle(context).copyWith(height: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getItemWidth(BuildContext ctx) {
    if (isDesktop(ctx)) return 120;
    if (isTablet(ctx)) return 100;
    return 85;
  }

  List<MenuItem> _getMenuItems() {
    return [
      MenuItem(
        title: 'Cari Asuransi',
        iconPath: 'assets/icons/cari-asuransi-1.svg',
        isPopular: true,
      ),
      MenuItem(
        title: 'Lapor \nKlaim',
        iconPath: 'assets/icons/lapor-klaim-2.svg',
      ),
      MenuItem(title: 'Aset', iconPath: 'assets/icons/aset-3.svg'),
      MenuItem(title: 'Polis', iconPath: 'assets/icons/polis-4.svg'),
      MenuItem(title: 'Beli Polis', iconPath: 'assets/icons/beli-polis-5.svg'),
      MenuItem(title: 'Klaim', iconPath: 'assets/icons/klaim-6.svg'),
      MenuItem(
        title: 'Tagihan Pembayaran',
        iconPath: 'assets/icons/tagihan-pembayaran-7.svg',
      ),
    ];
  }
}

class MenuItem {
  final String title;
  final String iconPath;
  final bool isPopular;

  MenuItem({
    required this.title,
    required this.iconPath,
    this.isPopular = false,
  });
}
