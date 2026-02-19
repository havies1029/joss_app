import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/constants.dart';
import '../../pages/notification/mobile/notification_page.dart';

AppBar MobileTopNavigationBar({
  required BuildContext context,
  required int selectedIndex,
  int notifCount = 2,
  VoidCallback? onNotifTap,
}) {
  const pageTitles = ['Beranda', 'Cari Asuransi', 'Lapor Klaim', 'Literasi', 'Pengaturan'];

  final isBeranda = selectedIndex == 0;

  return AppBar(
    toolbarHeight: !isBeranda ? 41 : 80,
    leadingWidth: 0,
    titleSpacing: 0,
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      child:
      isBeranda
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            gaplessPlayback: true,
            height:
            isDesktop(context)
                ? 56
                : isTablet(context)
                ? 48
                : 42,
            width:
            isDesktop(context)
                ? 180
                : isTablet(context)
                ? 140
                : 120,
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: onNotifTap ??
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationPage(),
                    ),
                  );
                },
            child: SvgPicture.asset(
              'assets/icons/notification.svg',
              height: 39,
              width: 40,
            ),
          ),
        ],
      )
      // Page lain
          : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: hPadding * 2,
          vertical: hPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Judul halaman
            Text(
              pageTitles[selectedIndex],
              style: bodyTextStyle(context, fontSize: 22),
              overflow: TextOverflow.ellipsis,
            ),

            // 🔸 Tagline "Claim Is Simple"
            Text(
              "Claim Is Simple",
              style: headingStyle(
                context,
                fontSize: getResponsiveFont(context, 18),
              ).copyWith(
                fontStyle: FontStyle.italic,
                color: primaryLightColor, // ganti sesuai warna brand lo
              ),
            ),
          ],
        ),
      ),
    ),
  );
}