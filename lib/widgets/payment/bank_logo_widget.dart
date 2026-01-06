import 'package:joss_app/helper/image_helper.dart';
import 'package:flutter/material.dart';

Widget buildBankLogo(
  String bankCode,
  String? logoUrl, {
  double size = 36,
}) {
  if (logoUrl != null && logoUrl.isNotEmpty) {
    return Image.network(
      logoUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Image.asset(
            ImageHelper.bankLogoAsset(bankCode),
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
    );
  }

  return Image.asset(
    ImageHelper.bankLogoAsset(bankCode),
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
}
