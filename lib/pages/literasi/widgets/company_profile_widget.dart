import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constants.dart';

class CompanyProfileCard extends StatelessWidget {
  final VoidCallback? onDownload;
  const CompanyProfileCard({super.key, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 392,
            height: 134,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/compro_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 0),
        Center(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                border: Border.all(color: sGrey),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/employee_shield.svg',
                    height: 40,
                  ),
                  RichText(
                    text: TextSpan(
                      style: bodyTextStyle(
                        context,
                        fontSize: 24,
                      ).copyWith(fontFamily: "Delm-Regular"),
                      children: [
                        const TextSpan(text: 'Company '),
                        TextSpan(
                          text: 'Profile',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  // Subjudul
                  Text(
                    'Semua tentang JPS dalam satu dokumen.',
                    style: bodyTextStyle(
                      context,
                      fontSize: 16,
                    ).copyWith(color: hintGrey),
                  ),
                  const SizedBox(height: 12),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.iconLeft(
                      text: 'Unduh Sekarang',
                      onPressed: onDownload ?? () {},
                      icon: SvgPicture.asset(
                        'assets/icons/download.svg',
                        height: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
