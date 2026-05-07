import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../blocs/notif_read/notif_read_bloc.dart';
import '../../common/constants.dart';
import '../../pages/notification/mobile/notification_page.dart';
import '../../pages/notification/mobile/test_notification.dart';

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
                    () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationPage(),
                    ),
                  );

                  if (context.mounted) {
                    context.read<NotifReadBloc>().add(RefreshNotifUnreadCountEvent());
                  }
                },
            child: BlocBuilder<NotifReadBloc, NotifReadState>(
              builder: (context, state) {
                final notifCount = state.unreadCount;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/notification.svg',
                      height: 39,
                      width: 40,
                    ),
                    if (notifCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              notifCount > 99 ? '99+' : notifCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/constants.dart';
import '../../pages/notification/mobile/notification_page.dart';
import '../../../blocs/notifevent/notifeventcari_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar MobileTopNavigationBar({
  required BuildContext context,
  required int selectedIndex,
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
                    MaterialPageRoute(builder: (_) => const NotificationPage()),
                  );
                },
            child: BlocBuilder<NotifeventcariBloc, NotifeventcariState>(
              buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
              builder: (context, state) {
                final count = state.unreadCount;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/notification.svg',
                      height: 39,
                      width: 40,
                    ),
                    if (count > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: pRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 10),
                                color: primaryLightColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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
*/