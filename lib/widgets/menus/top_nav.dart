import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/constants.dart';

AppBar MobileTopNavigationBar({
  required BuildContext context,
  int notifCount = 2,
  VoidCallback? onNotifTap,
}) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: Colors.transparent,
    title: Row(
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
              Image.asset(
                'assets/icons/notification.png',
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
                      borderRadius: BorderRadius.circular(cardBorderRadius),
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
    ),
  );
}
