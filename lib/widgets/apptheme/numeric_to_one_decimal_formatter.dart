import 'package:flutter/services.dart';

class NumericToOneDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(".", "");

    // Kalau kosong atau baru 1-2 digit → lanjutkan saja
    if (text.length <= 2) {
      return newValue.copyWith(text: text);
    }

    // Kalau sudah 3 digit → format jadi XX.X
    if (text.length == 3) {
      final formatted = "${text.substring(0, 2)}.${text.substring(2)}";
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Kalau lebih dari 3 digit → blok
    return oldValue;
  }
}
