import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class RiwayatTableStyle {
  static BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: formGrey,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: const Border(
        top: BorderSide(color: sGrey, width: 1),
        left: BorderSide(color: sGrey, width: 1),
        right: BorderSide(color: sGrey, width: 1),
        bottom: BorderSide(color: sGrey, width: 0.5),
      ),
    );
  }

  static const divider = Divider(height: 1, thickness: 1, color: sGrey);

  // ===== Compact widths (biar table-like & sejajar) =====
  static const double wNo = 50;
  static const double wInv = 170;
  static const double wTgl = 120;
  static const double wJml = 110;
  static const double wStatus = 150;
  static const double wTotal = 170;

  // ===== Cell box helper =====
  static Widget cellBox(
    String text, {
    double? width,
    bool center = false,
    FontWeight fontWeight = FontWeight.normal,
    Color? textColor,
    double fontSize = 15,
    EdgeInsets padding = const EdgeInsets.all(6),
  }) {
    final child = Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? primaryLightColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );

    return Container(
      width: width,
      padding: padding,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: center ? Center(child: child) : child,
    );
  }
}