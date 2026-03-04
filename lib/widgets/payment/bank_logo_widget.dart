import 'package:flutter/material.dart';
import '../../common/constants.dart';

String? _getLocalLogoPath(String? iconId) {
  if (iconId == null) return null;

  switch (iconId.toLowerCase()) {
    case 'bca':
      return 'assets/images/logo_va/logo_BCA.png';
    case 'bjb':
      return 'assets/images/logo_va/logo_BJB.png';
    case 'bni':
      return 'assets/images/logo_va/logo_BNI.png';
    case 'bri':
      return 'assets/images/logo_va/logo_BRI.png';
    case 'bsi':
      return 'assets/images/logo_va/logo_BSI.png';
    case 'bss':
      return 'assets/images/logo_va/logo_BSS.png';
    case 'bnc':
      return 'assets/images/logo_va/logo_BNC.png';
    case 'cimb':
      return 'assets/images/logo_va/logo_CIMB.png';
    case 'mandiri':
      return 'assets/images/logo_va/logo_Mandiri.png';
    case 'muamalat':
      return 'assets/images/logo_va/logo_Muamalat.png';
    case 'nnc':
      return 'assets/images/logo_va/logo_BNC.png';
    case 'permata':
      return 'assets/images/logo_va/logo_Permata.png';
    default:
      return 'assets/images/logo_va/logo_BNC.png';
  }
}

Widget buildBankLogo(String? iconId, String? iconUrl, {double size = 36}) {
  final localPath = _getLocalLogoPath(iconId);

  if (localPath != null) {
    return Image.asset(
      localPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  if (iconUrl != null && iconUrl.isNotEmpty) {
    return Image.network(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.account_balance, size: size, color: sGrey),
    );
  }

  return Icon(Icons.account_balance, size: size, color: sGrey);
}