import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../common/constants.dart';

class HelpContactCardWidget extends StatelessWidget {
  final String title; // contoh: "Butuh bantuan?"
  final String contactText; // contoh: "Hubungi 021-123456 atau support@email.com"
  final VoidCallback onPressed; // aksi tombol Hubungi

  const HelpContactCardWidget({
    super.key,
    required this.title,
    required this.contactText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icons_telephone.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryLightColor,
                        fontWeight: FontWeight.w600,
                        fontSize: getResponsiveFont(context, 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Baris bawah: teks kontak
                Text(
                  contactText,
                  style: TextStyle(
                    color: primaryLightColor,
                    fontSize: getResponsiveFont(context, 14),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Hubungi",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
