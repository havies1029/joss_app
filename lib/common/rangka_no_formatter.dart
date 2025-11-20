import 'package:flutter/services.dart';

class RangkaNoFormatter extends TextInputFormatter {
  final RegExp _allowed = RegExp(r'[A-Za-z0-9]');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Hapus spasi dan karakter ilegal
    String filtered = newValue.text.replaceAll(' ', '').toUpperCase();
    filtered = filtered.split('').where((c) => _allowed.hasMatch(c)).join();

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}
