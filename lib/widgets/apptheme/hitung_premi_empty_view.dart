import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/constants.dart';

class HitungPremiEmptyView extends StatelessWidget {
  final String title;
  final String description;

  const HitungPremiEmptyView({
    super.key,
    this.title = 'Belum ada perhitungan',
    this.description =
        'Silahkan tekan Tombol "Hitung Premi" untuk melihat perhitungannya.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      color: formGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/belum_ada.svg',
            height: 32,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: bodyTextStyle(context, fontSize: 18).copyWith(
              color: primaryLightColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: bodyTextStyle(context, fontSize: 14).copyWith(
              color: hintGrey,
            ),
          ),
        ],
      ),
    );
  }
}
