import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/constants.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../../base/base_background_sidepage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => notificationPage();
}

class notificationPage extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Notifikasi',
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _notificationItem(),
            _notificationItem2(),
            _notificationItem3(),
            // _centerContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/notification-1.svg",
            width: 40,
            height: 40,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update aplikasi versi 1.4 tersedia",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    color: primaryLightColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Perbarui sekarang untuk meningkatkan performa dan keamanan akun Anda. Nikmati pengalaman yang lebih stabil dan cepat.",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 16),
                    color: cGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationItem2() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/notification-1.svg",
            width: 40,
            height: 40,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Promo Spesial Idul Fitri 🎉",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    color: primaryLightColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Dapatkan tambahan diskon 20% untuk pembelian polis tertentu. Promo berlaku hingga 30 April 2026.",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 16),
                    color: cGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationItem3() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/notification-1.svg",
            width: 40,
            height: 40,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Polis akan jatuh tempo dalam 7 hari",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    color: primaryLightColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Polis No. 16251 akan berakhir pada 20 Feb 2026. Segera lakukan perpanjangan agar perlindungan tetap aktif.",
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 16),
                    color: cGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerContainer(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/icons/notification-1.svg",
              height: 50,
            ),
            const SizedBox(height: 20),

            Text(
              "Tidak Ada Notifikasi",
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                color: hintGrey,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              "Saat ini Anda belum menerima notifikasi apa pun.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getResponsiveFont(context, 14),
                color: hintGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

