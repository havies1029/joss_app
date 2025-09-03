library constants;

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:joss_app/common/size_config.dart';

part '../widgets/apptheme/textfield.dart';
part '../widgets/apptheme/button.dart';
part '../widgets/apptheme/snackbar.dart';
part '../widgets/apptheme/textstyles.dart';

/// Device/Platform Utils
bool get pIsMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
bool get pIsWeb => kIsWeb;

/// Device/Platform Utils
bool isMobile(BuildContext ctx) => MediaQuery.of(ctx).size.width < 650;
bool isTablet(BuildContext ctx) =>
    MediaQuery.of(ctx).size.width >= 650 &&
    MediaQuery.of(ctx).size.width < 1000;
bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 1000;

/// Color Palette
const Color primaryColor = Color(0xFFEF7A28);
const Color primaryLightColor = Color(0xFFF7F7F7);

const Color primaryBlackColor = Color(0xFF121212);
const Color secondaryBlackColor = Color(0xFF181818);

const Color pGrey = Color(0xFF292929);
const Color sGrey = Color(0xFF4E4E4E);
const Color hintGrey = Color(0xFFBCBCBC);

const Color pYellow = Color(0xFFEFA728);
const Color pBlue = Color(0xFF377BFC);
const Color pRed = Color(0xFFFF0000);
const Color pDarkRed = Color(0xFFDC1C1C);


const Color kategoriYellow = Color(0xFFFFC107);
const Color kategoriCream  = Color(0xFFFFFDD8);

const LinearGradient primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryBlackColor, primaryColor],
);

/// Padding & Spacing
const double hPadding = 10.0;
const double vPadding = 20.0;
const double cardBorderRadius = 10.0;
const double checkboxBorderRadius = 4.0;
const double defaultElevation = 3.0;
const double headerSpacing = 30.0;
const double fieldSpacing = 20.0;
const double buttonHeight = 41.0;

const double hPaddingForCard = 20.0;

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(
  r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kStringNullError = "Please enter some text";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: getProportionateScreenWidth(15),
  ),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: primaryLightColor),
  );
}

enum ListStatus { initial, success, failure }

const kAnimationDuration = Duration(milliseconds: 200);

/// Gradient Warna Oranye Smooth

/// Horizontal (gelap → terang)
const LinearGradient orangeSmoothGradientHorizontal = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFEF7A28), // gelap (orange tua)
    Color(0xFFFFCDA9), // terang (peach)
  ],
);

/// Vertical (terang → gelap)
const LinearGradient orangeSmoothGradientVertical = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFFCDA9), // terang di atas
    Color(0xFFEF7A28), // gelap di bawah
  ],
);

/// Horizontal (gelap -> terang)
const LinearGradient blackFadeGradientHorizontal = LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  colors: [
    Color(0x00181818), // kanan transparan (0%)
    Color(0xFF181818), // kiri gelap (100%)
  ],
);

/// Gradient Hitam Transparan (Kiri → Kanan, terang → gelap)
const LinearGradient blackFadeGradientHorizontalReversed = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0x00181818), // kiri transparan (0%)
    Color(0xFF181818), // kanan gelap (100%)
  ],
);

/// Gradient Oranye → Hitam (Vertikal, atas → bawah)
const LinearGradient orangeToBlackGradientVertical = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFEF7A28), // oranye di atas
    Color(0xFF121212), // hitam di bawah
  ],
  stops: [0.0, 1.0],
);

InputDecoration customInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      color: primaryColor, // label oranye
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: sGrey, // background field abu-abu
    hintStyle: const TextStyle(color: hintGrey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      borderSide: const BorderSide(color: sGrey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
  );
}

InputDecoration customDropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      color: primaryColor, // label oranye
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: sGrey, // background field abu-abu
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      borderSide: const BorderSide(color: sGrey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
  );
}

Widget appButton({
  required String text,
  required VoidCallback onPressed,
  double? width,
  double height = 56,
  Color backgroundColor = primaryColor,
  Color textColor = primaryLightColor,
  double borderRadius = cardBorderRadius,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w600,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        padding: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}
