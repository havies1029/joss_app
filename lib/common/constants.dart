library constants;

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:joss_app/common/size_config.dart';

part '../widgets/apptheme/textfield.dart';
part '../widgets/apptheme/button.dart';
part '../widgets/apptheme/snackbar.dart';

/// Device/Platform Utils
bool get pIsMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
bool get pIsWeb => kIsWeb;

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

const LinearGradient primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryBlackColor, primaryColor],
);

/// Padding & Spacing
const double hPadding = 20.0;
const double vPadding = 20.0;
const double cardBorderRadius = 10.0;
const double checkboxBorderRadius = 4.0;
const double defaultElevation = 3.0;
const double headerSpacing = 30.0;
const double fieldSpacing = 20.0;
const double buttonHeight = 41.0;

/// Responsive Font Size
double getResponsiveFont(BuildContext context, double base) {
  // Responsive: mobile (1x), tablet (1.15x), desktop (1.25x)
  double width = MediaQuery.of(context).size.width;
  if (width >= 1000) return base * 1.22; // desktop
  if (width >= 650) return base * 1.12; // tablet
  return base;
}

/// Text Styles
TextStyle heading1Style(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 30), color: primaryLightColor);

TextStyle inputHintStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 18), color: sGrey);

TextStyle linkStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 18), color: pBlue);

TextStyle linkActionStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 18), color: primaryColor);

TextStyle labelInputStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 18), color: primaryColor);

TextStyle labelStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 18), color: primaryLightColor);

TextStyle bodyStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 14), color: primaryLightColor);

TextStyle captionStyle(BuildContext ctx) => TextStyle(
  fontSize: getResponsiveFont(ctx, 12),
  color: primaryLightColor.withOpacity(0.7),
);

TextStyle errorTextStyle(BuildContext ctx) => TextStyle(
  color: pRed,
  fontSize: getResponsiveFont(ctx, 15)
);

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