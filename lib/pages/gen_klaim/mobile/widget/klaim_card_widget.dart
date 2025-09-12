import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../common/constants.dart';

class KlaimCardWidget extends StatelessWidget {
  const KlaimCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5, // jarak kiri kanan
        vertical: vPadding / 2,     // jarak atas bawah
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBlackColor, // warna background hitam
        borderRadius: BorderRadius.circular(cardBorderRadius), // sudut custom
      ),
      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lingkaran dengan border
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pGrey,
              border: Border.all(
                color: sGrey,
                width: 2,
              ),
            ),
            child: SvgPicture.asset(
              "assets/icons/shield2.svg",
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Klaim",
                  style: headingStyle(context).copyWith(
                    fontSize: getResponsiveFont(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ajukan klaim Anda dengan mudah dan cepat "
                      "sesuai ketentuan polis yang berlaku.",
                  style: bodyTextStyle(context).copyWith(
                    fontSize: getResponsiveFont(context, 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
