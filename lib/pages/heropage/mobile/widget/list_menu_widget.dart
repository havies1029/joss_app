import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../asset_management/mobile/asset_management_page.dart';
import '../../../gen_aset_dashboard/asetdashboardcari_main.dart';
import '../../../gen_aset_ringkasan/asetringkasancari_main.dart';
import '../../../gen_klaim/klaim1list_main.dart';
import '../../../gen_klaim/mobile/klaim_main_page.dart';
import '../../../gen_status_aset/statusasetcari_main.dart';
import '../../../cari_asuransi/mobile/cari_asuransi_page.dart';
import '../../../register/mobile/client/register_client_page.dart';

class ListMenuWidget extends StatelessWidget {
  final String custType;

  const ListMenuWidget({super.key, required this.custType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (custType != 'C')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildDaftarKlienButton(context),
          ),

        // Container utama untuk menu
        Container(
          decoration: BoxDecoration(
            color: secondaryBlackColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(cardBorderRadius),
              bottomRight: Radius.circular(cardBorderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 🔹 Bagian kanan: "Lihat Semua" + icon
                    Row(
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
                  ],
                ),
              ),
              _buildHorizontalMenu(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaftarKlienButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterClient()),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: primaryBadgeGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(cardBorderRadius),
            topRight: Radius.circular(cardBorderRadius),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(cardBorderRadius),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Icon(Icons.star, color: pYellow, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Daftar Klien',
                      style: headingStyle(context, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mudah dan Cepat!', style: bodyTextStyle(context)),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: primaryLightColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalMenu(BuildContext context) {
    final menuItems = _getMenuItems();
    final itemWidth = getItemWidth(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 145,
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return SizedBox(
                  width: itemWidth,
                  child: _buildMenuItem(context, item, custType),
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

  Widget _buildMenuItem(BuildContext context, MenuItem item, String custType) {
    final isClient = custType == 'C';
    final isAlwaysActive =
        item.title == "Cari Asuransi" || item.title == "Lapor \nKlaim";

    // aktif kalau client, atau kalau menu khusus
    final isActive = isClient || isAlwaysActive;

    return GestureDetector(
      onTap:
          isActive
              ? () {
                final page = getMenuPage(item.title);
                if (page != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    infoSnackBar('Fitur ${item.title} belum tersedia!'),
                  );
                }
              }
              : null,

      child: Opacity(
        opacity: isActive ? 1.0 : 0.4, // nonaktif jadi pudar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔵 Icon Circle
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
                      color: isActive ? pGrey : Colors.grey.shade800,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? sGrey : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.iconPath,
                        width: 38,
                        height: 38,
                        colorFilter:
                            isActive
                                ? null
                                : const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                ),
                      ),
                    ),
                  ),

                  // 🟠 Badge Populer
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
                          gradient: primaryBadgeGradient,
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

            // 📝 Title
            Expanded(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyTextStyle(context).copyWith(
                  height: 1,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: hPadding),
          ],
        ),
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

  Widget? getMenuPage(String title) {
    switch (title) {
      case 'Cari Asuransi':
        return CariAsuransiPage(); // Ganti ke page lo
      // case 'Lapor \nKlaim':
      //   return LaporKlaimPage();
      case 'Aset':
        return AssetManagementPage();
      // case 'Polis':
      //   return PolisListPage();
      // case 'Beli Polis':
      //   return BeliPolisPage();
      case 'Klaim':
        return KlaimMainPage();
      // case 'Tagihan Pembayaran':
      //   return TagihanPembayaranPage();
      default:
        return null; // atau return Placeholder(), terserah
    }
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
