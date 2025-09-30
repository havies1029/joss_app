import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/constants.dart';

class HeaderAsuransiCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final VoidCallback? onTap;

  const HeaderAsuransiCard({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: orangeToBlackGradient, // 🔶 pakai variabel dari constants.dart
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        onTap: onTap,
        child: Row(
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(
                iconPath!,
                color: Colors.white,
                width: 32,  // bisa disesuaikan
                height: 32, // bisa disesuaikan
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryLightColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
