import 'package:flutter/services.dart';

class PlatNomorFormatter extends TextInputFormatter {
  final RegExp _letters = RegExp(r'[A-Za-z]');
  final RegExp _numbers = RegExp(r'[0-9]');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Boleh kosong
    if (newValue.text.isEmpty) return newValue;

    // Buang spasi, jadi huruf besar
    String raw = newValue.text.replaceAll(' ', '').toUpperCase();

    String part1 = '';
    String part2 = '';
    String part3 = '';

    int state = 1; // 1 = huruf depan, 2 = angka, 3 = huruf belakang

    for (int i = 0; i < raw.length; i++) {
      final c = raw[i];

      if (state == 1) {
        if (_letters.hasMatch(c)) {
          if (part1.length >= 2) {
            // huruf depan nggak boleh lebih dari 2
            return oldValue;
          }
          part1 += c;
        } else if (_numbers.hasMatch(c)) {
          // angka tidak boleh muncul sebelum ada minimal 1 huruf
          if (part1.isEmpty) {
            return oldValue;
          }
          state = 2;
          part2 += c;
        } else {
          // karakter ilegal
          return oldValue;
        }
      } else if (state == 2) {
        if (_numbers.hasMatch(c)) {
          if (part2.length >= 4) {
            // angka maksimal 4 digit
            return oldValue;
          }
          part2 += c;
        } else if (_letters.hasMatch(c)) {
          // pindah ke huruf belakang, tapi harus sudah ada minimal 1 angka
          if (part2.isEmpty) {
            return oldValue;
          }
          state = 3;
          part3 += c;
        } else {
          return oldValue;
        }
      } else if (state == 3) {
        if (_letters.hasMatch(c)) {
          if (part3.length >= 3) {
            // huruf belakang maksimal 3
            return oldValue;
          }
          part3 += c;
        } else {
          // di part3 nggak boleh angka
          return oldValue;
        }
      }
    }

    // build formatted string dengan spasi
    String formatted = part1;
    if (part2.isNotEmpty) formatted += ' $part2';
    if (part3.isNotEmpty) formatted += ' $part3';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
