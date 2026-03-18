class IndoPhoneResult {
  final String? phone62; // hasil normalisasi: 628xxxx
  final String? error;

  const IndoPhoneResult._(this.phone62, this.error);

  factory IndoPhoneResult.success(String phone) =>
      IndoPhoneResult._(phone, null);

  factory IndoPhoneResult.fail(String message) =>
      IndoPhoneResult._(null, message);

  bool get isValid => phone62 != null;
}

class IndoPhoneHelper {
  static String _clean(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static IndoPhoneResult normalize(String rawInput) {
    final digits = _clean(rawInput);

    if (digits.length <= 8 || digits.length > 13) {
      return IndoPhoneResult.fail('Nomor harus 9–13 digit');
    }

    String normalized;

    if (digits.startsWith('62')) {
      normalized = digits;
    }
    else if (digits.startsWith('0')) {
      normalized = '62${digits.substring(1)}';
    }
    else if (digits.startsWith('8')) {
      normalized = '62$digits';
    }
    else {
      return IndoPhoneResult.fail(
        'Nomor harus diawali 62, 0, atau 8',
      );
    }

    if (!normalized.startsWith('628')) {
      return IndoPhoneResult.fail('Harus nomor HP Indonesia');
    }

    return IndoPhoneResult.success(normalized);
  }

  static String toDisplay(String? rawInput) {
    if (rawInput == null || rawInput.trim().isEmpty) return '';

    final digits = _clean(rawInput);

    if (digits.startsWith('62')) {
      return digits.substring(2);
    }

    if (digits.startsWith('0')) {
      return digits.substring(1);
    }

    return digits;
  }

  /// Shortcut: cek valid atau tidak
  static bool isValid(String input) {
    return normalize(input).isValid;
  }
}