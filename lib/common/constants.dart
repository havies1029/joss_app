library;

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

part '../widgets/apptheme/textfield.dart';
part '../widgets/apptheme/button.dart';
part '../widgets/apptheme/snackbar.dart';
part '../widgets/apptheme/textstyles.dart';
part '../widgets/apptheme/dropdown.dart';
part '../widgets/apptheme/checkbox_widget.dart';


DateTime? parseDate(dynamic value) {
  if (value == null) return null;

  final str = value.toString().trim();
  if (str.isEmpty) return null;

  return DateTime.tryParse(str);
}

const List<String> scopes = <String>[
  'email',
];

/// Device/Platform Utils
bool get pIsMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
bool get pIsWeb => kIsWeb;

/// Device/Platform Utils
bool isMobile(BuildContext ctx) => MediaQuery.of(ctx).size.width < 650;
bool isTablet(BuildContext ctx) =>
    MediaQuery.of(ctx).size.width >= 650 &&
    MediaQuery.of(ctx).size.width < 1000;
bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 1000;

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    orientation = _mediaQueryData?.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight!;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth!;
  return (inputWidth / 375.0) * screenWidth;
}

final RegExp phoneValidatorRegExp =
RegExp(r'^(?:\+62|62|0)[0-9]{9,13}$');

/// Color Palette
const Color primaryColor = Color(0xFFEF7A28);
const Color primaryLightColor = Color(0xFFF7F7F7);
  const Color labelLightColor = Color(0xFF5E5E5E);


const Color primaryBlackColor = Color(0xFF121212);
const Color secondaryBlackColor = Color(0xFF181818);

const Color cardGrey = Color(0xFF8C8C8C);
const Color formGrey = Color(0xFF333333);
const Color pGrey = Color(0xFF292929);
const Color sGrey = Color(0xFF4E4E4E);
const Color hintGrey = Color(0xFFBCBCBC);
const Color unselectedColor = Color(0xFF666666);
const Color scrollBar = Color(0xFFD9D9D9);
const Color greyKlaim = Color(0xFFA8A8A8);

const Color bGrey = Color(0xFFA1A1AA);
const Color bdGrey = Color(0xFFBCBCC7);
const Color bBlue = Color(0xFF295EFF);
const Color bdBlue = Color(0xFF5D86FF);
const Color cGrey = Color(0xFFA1A1A1);

const Color pYellow = Color(0xFFEFA728);
const Color pBlue = Color(0xFF377BFC);
const Color sBlue = Color(0xFF0088FF);
const Color pRed = Color(0xFFFF0000);
const Color pGreen = Color(0xFF90DE24);
const Color successGreen = Color(0xFF4BB34B);
const Color greenforPayment = Color(0xFF12C127);
const Color pDarkRed = Color(0xFFDC1C1C);
const Color pSlowRed = Color(0xFFFF0E12);
const Color kategoriYellow = Color(0xFFFFC107);
const Color kategoriCream = Color(0xFFFFFDD8);
const Color excelGreen = Color(0xFF27AE68);
const Color pdfRed = Color(0xFFDA1618);

const Color transactionColor1 = Color(0xFF3C3C3C);
const Color transactionColor2 = Color(0xFF343434);
// 🔥 Direct LinearGradients (Light → Dark, top → bottom)

const LinearGradient yellowGradient = LinearGradient(
  colors: [Color(0xFFFFCA46), Color(0xFFD59900)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient blueGradient = LinearGradient(
  colors: [Color(0xFF61C8FF), Color(0xFF0486CD)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient cyanGradient = LinearGradient(
  colors: [Color(0xFF48E0FF), Color(0xFF02B1D5)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient purpleGradient = LinearGradient(
  colors: [Color(0xFF9B82FF), Color(0xFF533BB6)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient redGradient = LinearGradient(
  colors: [Color(0xFFFF393D), Color(0xFFAC0A0D)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient greenGradient = LinearGradient(
  colors: [Color(0xFF42EF48), Color(0xFF05AD0A)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);


/// Padding & Spacing
const double hPadding = 10.0;
const double vPadding = 20.0;
const double cardBorderRadius = 10.0;
const double checkboxBorderRadius = 4.0;
const double defaultElevation = 3.0;
const double buttonHeight = 41.0;

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(
  r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

const String kEmailNullError = "Email wajib diisi.";
const String kInvalidEmailError = "Format email tidak valid.";
const String kPassNullError = "Password wajib diisi.";
const String kShortPassError = "Password terlalu pendek (minimal 6 karakter).";
const String kMatchPassError = "Konfirmasi password tidak sama.";
const String kNameNullError = "Nama wajib diisi.";
const String kPhoneNumberNullError = "Nomor telepon wajib diisi.";
const String kAddressNullError = "Alamat wajib diisi.";
const String kStringNullError = "Bagian ini wajib diisi.";
const String kStringProvinsiError = "Provinsi wajib diisi.";
const String kStringKotaError = "Kota wajib diisi.";
const String kStringKodeposError = "Kode Pos wajib diisi.";
const String kString0 = "Harus lebih dari 0.";

enum ListStatus { initial, success, failure, loadingMore }


const kAnimationDuration = Duration(milliseconds: 200);

/// Divider
Widget kDivider({Color? color}) => Divider(height: 1, color: color ?? pGrey);
const Widget sDivider = Divider(
  height: 1,
  color: sGrey,
  indent: 20,
  endIndent: 20,
);

/// Gradient
const LinearGradient primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryBlackColor, primaryColor],
);

const LinearGradient primaryBlackGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [primaryColor, primaryBlackColor],
);

const LinearGradient registerButtonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFF8732), Color(0xFFFFCC92), Color(0xFFFF8732)],
  stops: [0.0, 0.48, 1.0],
);

const LinearGradient cardBorderGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    primaryColor,
    primaryBlackColor,
    primaryBlackColor,
    primaryBlackColor,
    primaryBlackColor,
    primaryBlackColor,
    primaryBlackColor,
    primaryBlackColor,
  ],
  stops: [0.0, 0.05, 0.2, 0.4, 0.6, 0.75, 0.9, 1.0],
);

// Horizontal (gelap → terang)
const LinearGradient primaryBadgeGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [primaryColor, Color(0xFFFFCDA9)],
);

// Gradient untuk menu
const LinearGradient blackFadeGradientHorizontal = LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  colors: [Color(0x00181818), Color(0xFF181818)],
);

// Gradient untuk menu
const LinearGradient blackFadeGradientHorizontalReversed = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0x00181818), Color(0xFF181818)],
);

const LinearGradient orangeToBlackGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFEF7A28), // oranye
    Color(0xFF181818), // hitam
  ],
  stops: [
    0.0,  // oranye mulai
    0.9,  // hitam lebih cepat "menguasai" (80% posisi sudah hitam)
  ],
);

enum StatusType {
  aktif("10002", "assets/icons/aktif.svg", pGreen),
  nonAktif("10003", "assets/icons/nonaktif.svg", pRed),
  onProgress("10004", "assets/icons/diproses.svg", pYellow),
  berakhir("10005", "assets/icons/nonaktif.svg", pBlue);

  final String id;
  final String asset;
  final Color color;
  const StatusType(this.id, this.asset, this.color);


  static StatusType? fromId(String id) {
    for (final t in StatusType.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}
