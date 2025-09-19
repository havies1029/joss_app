library constants;

import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

part '../widgets/apptheme/textfield.dart';
part '../widgets/apptheme/button.dart';
part '../widgets/apptheme/snackbar.dart';
part '../widgets/apptheme/textstyles.dart';
part '../widgets/apptheme/dropdown.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: const ['email'],
  clientId:
      kIsWeb
          ? '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com'
          : null,
  serverClientId:
      kIsWeb
          ? null
          : '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com',
);

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

/// Color Palette
const Color primaryColor = Color(0xFFEF7A28);
const Color primaryLightColor = Color(0xFFF7F7F7);

const Color primaryBlackColor = Color(0xFF121212);
const Color secondaryBlackColor = Color(0xFF181818);

const Color formGrey = Color(0xFF333333);
const Color pGrey = Color(0xFF292929);
const Color sGrey = Color(0xFF4E4E4E);
const Color hintGrey = Color(0xFFBCBCBC);
const Color unselectedColor = Color(0xFF666666);

const Color pYellow = Color(0xFFEFA728);
const Color pBlue = Color(0xFF377BFC);
const Color pRed = Color(0xFFFF0000);
const Color pGreen = Color(0xFF90DE24);
const Color pDarkRed = Color(0xFFDC1C1C);

const Color kategoriYellow = Color(0xFFFFC107);
const Color kategoriCream = Color(0xFFFFFDD8);

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

enum ListStatus { initial, success, failure }

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