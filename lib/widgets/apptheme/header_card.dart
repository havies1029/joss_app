import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../common/constants.dart';

class HeaderCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;

  const HeaderCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      decoration: BoxDecoration(
        gradient: orangeToBlackGradientVertical, // border gradient
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(1), // ketebalan border gradient
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius - 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Box/Icon kiri
            Container(
              padding: const EdgeInsets.all(13.24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: formGrey,
                border: Border.all(color: sGrey),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 12),
            // Teks kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: headingStyle(context, fontSize: 20),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: bodyTextStyle(
                      context,
                      fontSize: 16,
                    ).copyWith(color: hintGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}