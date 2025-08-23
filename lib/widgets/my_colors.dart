import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);

  static const Color primaryYellow = Color(0xFFFEBA2B);
  static const Color primaryOrange = Color(0xFFF2733D);
  static const Color secondaryGrey = Color(0xFF757575);
  static const Color secondaryBlue = Color(0xFF0386D0);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);

  static const Color overlayLight_5 = Color(0x0dffffff);
  static const Color overlayLight_10 = Color(0x1AFFFFFF);
  static const Color overlayLight_20 = Color(0x33FFFFFF);
  static const Color overlayLight_30 = Color(0x4DFFFFFF);
  static const Color overlayLight_40 = Color(0x66FFFFFF);
  static const Color overlayLight_50 = Color(0x80FFFFFF);

  static const Color overlayDark_5 = Color(0x0d000000);
  static const Color overlayDark_10 = Color(0x1A000000);
  static const Color overlayDark_20 = Color(0x33000000);
  static const Color overlayDark_30 = Color(0x4D000000);
  static const Color overlayDark_40 = Color(0x66000000);
  static const Color overlayDark_50 = Color(0x80000000);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class PolisExpColor {
  static Color backgroundColor(int severity) {
    Color backColor = (severity == 10
        ? Colors.red[900]
        : severity == 20
            ? Colors.red[400]
            : severity == 30
                ? Colors.red[200]
                : severity == 40
                    ? Colors.amber[200]
                    : Colors.green) as Color;

    return backColor;
  }

  static Color labelColor(int severity) {
    Color textColor = (severity == 10
        ? Colors.white
        : severity == 20
            ? Colors.amber[50]
            : severity == 30
                ? MyColors.grey_80
                : severity == 40
                ? MyColors.grey_80
                : Colors.white) as Color;

    return textColor;
  }

  static Color textColor(int severity) {
    Color textColor = (severity == 10
        ? Colors.white
        : severity == 20
            ? Colors.amber[50]
            : severity == 50
                ? Colors.white
                : MyColors.grey_80) as Color;

    return textColor;
  }
}

class SoaAgingColor {
  static Color backgroundColor(int severity) {
    Color backColor = (severity == 1
        ? Colors.red[900]
        : severity == 2
            ? Colors.red[400]
            : severity == 3
                ? Colors.red[200]
                : severity == 4
                    ? Colors.amber[200]
                    : severity == 5
                      ? Colors.amber[600]
                      : severity == 6
                        ? Colors.green
                        : Colors.blue) as Color;

    return backColor;
  }

  static Color labelColor(int severity) {
    Color textColor = (severity == 1
        ? Colors.white
        : severity == 2
            ? Colors.amber[50]
            : severity == 3
                ? MyColors.grey_80
                : severity == 4
                  ? MyColors.grey_80
                  : Colors.white) as Color;

    return textColor;
  }

  static Color textColor(int severity) {
    Color textColor = (severity == 1
        ? Colors.white
        : severity == 2
            ? Colors.amber[50]
            : severity == 3
                ? Colors.white
                : MyColors.grey_80) as Color;

    return textColor;
  }
}