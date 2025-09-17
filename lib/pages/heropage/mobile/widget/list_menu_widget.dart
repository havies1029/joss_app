import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../asset_management/mobile/asset_management_page.dart';
import '../../../gen_aset_dashboard/asetdashboardcari_main.dart';
import '../../../gen_aset_ringkasan/asetringkasancari_main.dart';
import '../../../gen_klaim/klaim1list_main.dart';
import '../../../gen_klaim/mobile/klaim_main_page.dart';
import '../../../gen_status_aset/statusasetcari_main.dart';
import '../../../register/mobile/client/register_client_page.dart';

class ListMenuWidget extends StatelessWidget {
  final String custType; // 👈 tambahin ini

  const ListMenuWidget({super.key, required this.custType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Button Daftar Klien di luar container utama
        if (custType != 'C')
        // 🔹 PERUBAHAN: Hilangkan padding vertical agar menempel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildDaftarKlienButton(context),
          ),

        // 🔹 Container utama untuk menu
        Container(
          decoration: BoxDecoration(
            color: secondaryBlackColor,
            // 🔹 OPSIONAL: Tambahkan radius bawah jika diperlukan
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(cardBorderRadius),
              bottomRight: Radius.circular(cardBorderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          gradient: orangeSmoothGradientHorizontal,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(cardBorderRadius),
            topRight: Radius.circular(cardBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
              children: [
                // 🔹 Daftar Klien (pakai border kanan sebagai pemisah)
                // 🔹 Daftar Klien (pakai border kanan bawah radius)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(cardBorderRadius), // 🔹 radius bawah kanan
                    ),
                  ),
                  clipBehavior: Clip.antiAlias, // supaya radius kepotong rapi
                  child: Row(
                    children: [
                      Icon(Icons.star, color: pYellow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Klien',
                        style: TextStyle(
                          color: primaryLightColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),


                // 🔹 Mudah dan Cepat
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: primaryLightColor, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Mudah dan Cepat!',
                              style: TextStyle(
                                color: primaryLightColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: primaryLightColor, size: 16),
                      ],
                    ),
                  ),
                ),
              ]

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
      onTap: isActive
          ? () {
        switch (item.title) {
          case 'Cari Asuransi':
            Navigator.pushNamed(context, '/cariAsuransi');
            break;
          case 'Lapor \nKlaim':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const KlaimMainPage(),
              ),
            );
            break;
          case 'Aset':
            Navigator.push(
              context,MaterialPageRoute(
                builder: (_) => const AssetManagementPage(),
              ),
            );
            break;
          case 'Polis':
            Navigator.pushNamed(context, '/polis');
            break;
          case 'Beli Polis':
            Navigator.pushNamed(context, '/beliPolis');
            break;
          case 'Klaim':
            Navigator.pushNamed(context, '/klaim');
            break;
          case 'Tagihan Pembayaran':
            Navigator.pushNamed(context, '/tagihan');
            break;
          default:
            debugPrint('Menu ${item.title} belum ada action');
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
                        colorFilter: isActive
                            ? null
                            : const ColorFilter.mode(
                            Colors.grey, BlendMode.srcIn),
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
                          gradient: orangeSmoothGradientHorizontal,
                        ),
                        child: Text(
                          'Populer!',
                          style: bodyTextStyle(context).copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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
            const SizedBox(height: hPadding)
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
