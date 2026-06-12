import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/constants.dart';

String? _getLocalLogoPath(String? iconId) {
  if (iconId == null) return null;

  switch (iconId.toLowerCase()) {
    case 'bjb':
      return 'assets/bank_logo/bjb.svg';
    case 'bss':
      return 'assets/bank_logo/bss.svg';
    case 'bca':
      return 'assets/bank_logo/bca.svg';
    case 'bnc':
      return 'assets/bank_logo/bnc.svg';
    case 'bni':
      return 'assets/bank_logo/bni.svg';
    case 'bri':
      return 'assets/bank_logo/bri.svg';
    case 'bsi':
      return 'assets/bank_logo/bsi.svg';
    case 'cimb':
      return 'assets/bank_logo/cimb.svg';
    case 'mandiri':
      return 'assets/bank_logo/mandiri.svg';
    case 'muamalat':
      return 'assets/bank_logo/muamalat.svg';
    case 'nnc':
      return 'assets/bank_logo/bnc.svg';
    case 'permata':
      return 'assets/bank_logo/permata.svg';
    default:
      return null;
  }
}

Widget buildBankLogo(String? iconId, String? iconUrl, {double size = 36}) {
  final localPath = _getLocalLogoPath(iconId);

  if (localPath != null) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: SvgPicture.asset(
        localPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  if (iconUrl != null && iconUrl.isNotEmpty) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: Image.network(
        iconUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder(size);
        },
        errorBuilder: (_, __, ___) => _placeholder(size),
      ),
    );
  }

  return _placeholder(size);
}

Widget _placeholder(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: SvgPicture.asset(
        'assets/icons/place_holder_2.svg',
        width: size * 0.6,
        height: size * 0.6,
        fit: BoxFit.contain,
      ),
    ),
  );
}