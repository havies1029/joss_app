import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

import 'hero_header_widget.dart';
import 'premi_polis_summary_widget.dart';

class HeroCardWidget extends StatelessWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;

  final String premiumAmount;
  final int polisCount;

  final VoidCallback? onDetailTap;
  final String userType;

  const HeroCardWidget({
    super.key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.premiumAmount,
    required this.polisCount,
    this.onDetailTap,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding + 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius * 2),
        gradient: primaryBlackGradient,
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: secondaryBlackColor,
          borderRadius: BorderRadius.circular(cardBorderRadius * 2 - 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            HeroHeaderWidget(
              userName: userName,
              imageBytes: imageBytes,
              userImage: userImage,
              userType: userType,
            ),

            const SizedBox(height: 16),

            PremiPolisSummaryWidget(
              userType: userType,
              onDetailTap: onDetailTap,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}