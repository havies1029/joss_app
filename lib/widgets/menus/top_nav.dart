import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/constants.dart';

AppBar MobileTopNavigationBar({
  required BuildContext context,
  required int selectedIndex,
  int notifCount = 2,
  VoidCallback? onNotifTap,
}) {
  const pageTitles = ['Beranda', 'Cari Asuransi', 'Cari Literasi', 'Pengaturan'];

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
                    'assets/icons/logo_jps_no_background.png',
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
                    onTap:
                        onNotifTap ??
                        () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(infoSnackBar('Notifikasi diklik!'));
                        },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/notification.svg',
                          height: 39,
                          width: 40,
                        ),
                        if (notifCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(vPadding / 10),
                              decoration: BoxDecoration(
                                color: pRed,
                                borderRadius: BorderRadius.circular(
                                  cardBorderRadius,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                notifCount > 99 ? '99+' : '$notifCount',
                                style: TextStyle(
                                  fontSize: getResponsiveFont(context, 10),
                                  color: primaryLightColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
              // Page lain
              : Container(
                padding: const EdgeInsets.symmetric(horizontal: hPadding*2, vertical: hPadding),
                child: Text(
                  pageTitles[selectedIndex],
                  style: bodyTextStyle(context, fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
    ),
  );
}
