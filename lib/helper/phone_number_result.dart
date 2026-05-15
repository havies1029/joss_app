class PhoneNumberResult {
  final String? phone;
  final String? error;

  const PhoneNumberResult._(this.phone, this.error);

  factory PhoneNumberResult.success(String phone) =>
      PhoneNumberResult._(phone, null);

  factory PhoneNumberResult.fail(String message) =>
      PhoneNumberResult._(null, message);

  bool get isValid => phone != null;
}

class PhoneNumberHelper {
  static String clean(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static PhoneNumberResult normalize(
      String rawInput, {
        int minLength = 6,
        int maxLength = 15,
        bool required = true,
      }) {
    final digits = clean(rawInput);

    if (digits.isEmpty) {
      if (!required) return PhoneNumberResult.success('');
      return PhoneNumberResult.fail('Nomor telepon tidak boleh kosong');
    }

    if (digits.length < minLength) {
      return PhoneNumberResult.fail(
        'Nomor telepon minimal $minLength digit',
      );
    }

    if (digits.length > maxLength) {
      return PhoneNumberResult.fail(
        'Nomor telepon maksimal $maxLength digit',
      );
    }

    return PhoneNumberResult.success(digits);
  }

  static bool isValid(
      String input, {
        int minLength = 5,
        int maxLength = 17,
        bool required = true,
      }) {
    return normalize(
      input,
      minLength: minLength,
      maxLength: maxLength,
      required: required,
    ).isValid;
  }
}