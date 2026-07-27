class PhoneCountryCode {
  final int dialCode;
  final String isoCode;
  final String name;

  const PhoneCountryCode({
    required this.dialCode,
    required this.isoCode,
    required this.name,
  });

  String get dialCodeText => dialCode.toString();
  String get displayText => '+$dialCodeText';
  String get searchText => '$displayText $name $isoCode';
}

class InternationalPhoneResult {
  final String? phone;
  final String? nationalNumber;
  final PhoneCountryCode? country;
  final String? error;

  const InternationalPhoneResult._({
    this.phone,
    this.nationalNumber,
    this.country,
    this.error,
  });

  factory InternationalPhoneResult.success({
    required String phone,
    required String nationalNumber,
    required PhoneCountryCode country,
  }) {
    return InternationalPhoneResult._(
      phone: phone,
      nationalNumber: nationalNumber,
      country: country,
    );
  }

  factory InternationalPhoneResult.fail(String message) {
    return InternationalPhoneResult._(error: message);
  }

  bool get isValid => phone != null;
}

class InternationalPhoneHelper {
  static const int defaultCountryCode = 62;

  static const List<PhoneCountryCode> countries = [
    PhoneCountryCode(
        dialCode: 1, isoCode: 'US', name: 'United States / Canada'),
    PhoneCountryCode(dialCode: 7, isoCode: 'RU', name: 'Russia / Kazakhstan'),
    PhoneCountryCode(dialCode: 20, isoCode: 'EG', name: 'Egypt'),
    PhoneCountryCode(dialCode: 27, isoCode: 'ZA', name: 'South Africa'),
    PhoneCountryCode(dialCode: 30, isoCode: 'GR', name: 'Greece'),
    PhoneCountryCode(dialCode: 31, isoCode: 'NL', name: 'Netherlands'),
    PhoneCountryCode(dialCode: 32, isoCode: 'BE', name: 'Belgium'),
    PhoneCountryCode(dialCode: 33, isoCode: 'FR', name: 'France'),
    PhoneCountryCode(dialCode: 34, isoCode: 'ES', name: 'Spain'),
    PhoneCountryCode(dialCode: 36, isoCode: 'HU', name: 'Hungary'),
    PhoneCountryCode(dialCode: 39, isoCode: 'IT', name: 'Italy'),
    PhoneCountryCode(dialCode: 40, isoCode: 'RO', name: 'Romania'),
    PhoneCountryCode(dialCode: 41, isoCode: 'CH', name: 'Switzerland'),
    PhoneCountryCode(dialCode: 43, isoCode: 'AT', name: 'Austria'),
    PhoneCountryCode(dialCode: 44, isoCode: 'GB', name: 'United Kingdom'),
    PhoneCountryCode(dialCode: 45, isoCode: 'DK', name: 'Denmark'),
    PhoneCountryCode(dialCode: 46, isoCode: 'SE', name: 'Sweden'),
    PhoneCountryCode(dialCode: 47, isoCode: 'NO', name: 'Norway'),
    PhoneCountryCode(dialCode: 48, isoCode: 'PL', name: 'Poland'),
    PhoneCountryCode(dialCode: 49, isoCode: 'DE', name: 'Germany'),
    PhoneCountryCode(dialCode: 51, isoCode: 'PE', name: 'Peru'),
    PhoneCountryCode(dialCode: 52, isoCode: 'MX', name: 'Mexico'),
    PhoneCountryCode(dialCode: 53, isoCode: 'CU', name: 'Cuba'),
    PhoneCountryCode(dialCode: 54, isoCode: 'AR', name: 'Argentina'),
    PhoneCountryCode(dialCode: 55, isoCode: 'BR', name: 'Brazil'),
    PhoneCountryCode(dialCode: 56, isoCode: 'CL', name: 'Chile'),
    PhoneCountryCode(dialCode: 57, isoCode: 'CO', name: 'Colombia'),
    PhoneCountryCode(dialCode: 58, isoCode: 'VE', name: 'Venezuela'),
    PhoneCountryCode(dialCode: 60, isoCode: 'MY', name: 'Malaysia'),
    PhoneCountryCode(dialCode: 61, isoCode: 'AU', name: 'Australia'),
    PhoneCountryCode(dialCode: 62, isoCode: 'ID', name: 'Indonesia'),
    PhoneCountryCode(dialCode: 63, isoCode: 'PH', name: 'Philippines'),
    PhoneCountryCode(dialCode: 64, isoCode: 'NZ', name: 'New Zealand'),
    PhoneCountryCode(dialCode: 65, isoCode: 'SG', name: 'Singapore'),
    PhoneCountryCode(dialCode: 66, isoCode: 'TH', name: 'Thailand'),
    PhoneCountryCode(dialCode: 81, isoCode: 'JP', name: 'Japan'),
    PhoneCountryCode(dialCode: 82, isoCode: 'KR', name: 'South Korea'),
    PhoneCountryCode(dialCode: 84, isoCode: 'VN', name: 'Vietnam'),
    PhoneCountryCode(dialCode: 86, isoCode: 'CN', name: 'China'),
    PhoneCountryCode(dialCode: 90, isoCode: 'TR', name: 'Turkey'),
    PhoneCountryCode(dialCode: 91, isoCode: 'IN', name: 'India'),
    PhoneCountryCode(dialCode: 92, isoCode: 'PK', name: 'Pakistan'),
    PhoneCountryCode(dialCode: 93, isoCode: 'AF', name: 'Afghanistan'),
    PhoneCountryCode(dialCode: 94, isoCode: 'LK', name: 'Sri Lanka'),
    PhoneCountryCode(dialCode: 95, isoCode: 'MM', name: 'Myanmar'),
    PhoneCountryCode(dialCode: 98, isoCode: 'IR', name: 'Iran'),
    PhoneCountryCode(dialCode: 211, isoCode: 'SS', name: 'South Sudan'),
    PhoneCountryCode(dialCode: 212, isoCode: 'MA', name: 'Morocco'),
    PhoneCountryCode(dialCode: 213, isoCode: 'DZ', name: 'Algeria'),
    PhoneCountryCode(dialCode: 216, isoCode: 'TN', name: 'Tunisia'),
    PhoneCountryCode(dialCode: 218, isoCode: 'LY', name: 'Libya'),
    PhoneCountryCode(dialCode: 220, isoCode: 'GM', name: 'Gambia'),
    PhoneCountryCode(dialCode: 221, isoCode: 'SN', name: 'Senegal'),
    PhoneCountryCode(dialCode: 222, isoCode: 'MR', name: 'Mauritania'),
    PhoneCountryCode(dialCode: 223, isoCode: 'ML', name: 'Mali'),
    PhoneCountryCode(dialCode: 224, isoCode: 'GN', name: 'Guinea'),
    PhoneCountryCode(dialCode: 225, isoCode: 'CI', name: 'Cote d Ivoire'),
    PhoneCountryCode(dialCode: 226, isoCode: 'BF', name: 'Burkina Faso'),
    PhoneCountryCode(dialCode: 227, isoCode: 'NE', name: 'Niger'),
    PhoneCountryCode(dialCode: 228, isoCode: 'TG', name: 'Togo'),
    PhoneCountryCode(dialCode: 229, isoCode: 'BJ', name: 'Benin'),
    PhoneCountryCode(dialCode: 230, isoCode: 'MU', name: 'Mauritius'),
    PhoneCountryCode(dialCode: 231, isoCode: 'LR', name: 'Liberia'),
    PhoneCountryCode(dialCode: 232, isoCode: 'SL', name: 'Sierra Leone'),
    PhoneCountryCode(dialCode: 233, isoCode: 'GH', name: 'Ghana'),
    PhoneCountryCode(dialCode: 234, isoCode: 'NG', name: 'Nigeria'),
    PhoneCountryCode(dialCode: 235, isoCode: 'TD', name: 'Chad'),
    PhoneCountryCode(
        dialCode: 236, isoCode: 'CF', name: 'Central African Republic'),
    PhoneCountryCode(dialCode: 237, isoCode: 'CM', name: 'Cameroon'),
    PhoneCountryCode(dialCode: 238, isoCode: 'CV', name: 'Cape Verde'),
    PhoneCountryCode(
        dialCode: 239, isoCode: 'ST', name: 'Sao Tome and Principe'),
    PhoneCountryCode(dialCode: 240, isoCode: 'GQ', name: 'Equatorial Guinea'),
    PhoneCountryCode(dialCode: 241, isoCode: 'GA', name: 'Gabon'),
    PhoneCountryCode(dialCode: 242, isoCode: 'CG', name: 'Congo'),
    PhoneCountryCode(dialCode: 243, isoCode: 'CD', name: 'Congo DR'),
    PhoneCountryCode(dialCode: 244, isoCode: 'AO', name: 'Angola'),
    PhoneCountryCode(dialCode: 245, isoCode: 'GW', name: 'Guinea Bissau'),
    PhoneCountryCode(
        dialCode: 246, isoCode: 'IO', name: 'British Indian Ocean Territory'),
    PhoneCountryCode(dialCode: 248, isoCode: 'SC', name: 'Seychelles'),
    PhoneCountryCode(dialCode: 249, isoCode: 'SD', name: 'Sudan'),
    PhoneCountryCode(dialCode: 250, isoCode: 'RW', name: 'Rwanda'),
    PhoneCountryCode(dialCode: 251, isoCode: 'ET', name: 'Ethiopia'),
    PhoneCountryCode(dialCode: 252, isoCode: 'SO', name: 'Somalia'),
    PhoneCountryCode(dialCode: 253, isoCode: 'DJ', name: 'Djibouti'),
    PhoneCountryCode(dialCode: 254, isoCode: 'KE', name: 'Kenya'),
    PhoneCountryCode(dialCode: 255, isoCode: 'TZ', name: 'Tanzania'),
    PhoneCountryCode(dialCode: 256, isoCode: 'UG', name: 'Uganda'),
    PhoneCountryCode(dialCode: 257, isoCode: 'BI', name: 'Burundi'),
    PhoneCountryCode(dialCode: 258, isoCode: 'MZ', name: 'Mozambique'),
    PhoneCountryCode(dialCode: 260, isoCode: 'ZM', name: 'Zambia'),
    PhoneCountryCode(dialCode: 261, isoCode: 'MG', name: 'Madagascar'),
    PhoneCountryCode(dialCode: 262, isoCode: 'RE', name: 'Reunion / Mayotte'),
    PhoneCountryCode(dialCode: 263, isoCode: 'ZW', name: 'Zimbabwe'),
    PhoneCountryCode(dialCode: 264, isoCode: 'NA', name: 'Namibia'),
    PhoneCountryCode(dialCode: 265, isoCode: 'MW', name: 'Malawi'),
    PhoneCountryCode(dialCode: 266, isoCode: 'LS', name: 'Lesotho'),
    PhoneCountryCode(dialCode: 267, isoCode: 'BW', name: 'Botswana'),
    PhoneCountryCode(dialCode: 268, isoCode: 'SZ', name: 'Eswatini'),
    PhoneCountryCode(dialCode: 269, isoCode: 'KM', name: 'Comoros'),
    PhoneCountryCode(dialCode: 290, isoCode: 'SH', name: 'Saint Helena'),
    PhoneCountryCode(dialCode: 291, isoCode: 'ER', name: 'Eritrea'),
    PhoneCountryCode(dialCode: 297, isoCode: 'AW', name: 'Aruba'),
    PhoneCountryCode(dialCode: 298, isoCode: 'FO', name: 'Faroe Islands'),
    PhoneCountryCode(dialCode: 299, isoCode: 'GL', name: 'Greenland'),
    PhoneCountryCode(dialCode: 350, isoCode: 'GI', name: 'Gibraltar'),
    PhoneCountryCode(dialCode: 351, isoCode: 'PT', name: 'Portugal'),
    PhoneCountryCode(dialCode: 352, isoCode: 'LU', name: 'Luxembourg'),
    PhoneCountryCode(dialCode: 353, isoCode: 'IE', name: 'Ireland'),
    PhoneCountryCode(dialCode: 354, isoCode: 'IS', name: 'Iceland'),
    PhoneCountryCode(dialCode: 355, isoCode: 'AL', name: 'Albania'),
    PhoneCountryCode(dialCode: 356, isoCode: 'MT', name: 'Malta'),
    PhoneCountryCode(dialCode: 357, isoCode: 'CY', name: 'Cyprus'),
    PhoneCountryCode(dialCode: 358, isoCode: 'FI', name: 'Finland'),
    PhoneCountryCode(dialCode: 359, isoCode: 'BG', name: 'Bulgaria'),
    PhoneCountryCode(dialCode: 370, isoCode: 'LT', name: 'Lithuania'),
    PhoneCountryCode(dialCode: 371, isoCode: 'LV', name: 'Latvia'),
    PhoneCountryCode(dialCode: 372, isoCode: 'EE', name: 'Estonia'),
    PhoneCountryCode(dialCode: 373, isoCode: 'MD', name: 'Moldova'),
    PhoneCountryCode(dialCode: 374, isoCode: 'AM', name: 'Armenia'),
    PhoneCountryCode(dialCode: 375, isoCode: 'BY', name: 'Belarus'),
    PhoneCountryCode(dialCode: 376, isoCode: 'AD', name: 'Andorra'),
    PhoneCountryCode(dialCode: 377, isoCode: 'MC', name: 'Monaco'),
    PhoneCountryCode(dialCode: 378, isoCode: 'SM', name: 'San Marino'),
    PhoneCountryCode(dialCode: 379, isoCode: 'VA', name: 'Vatican City'),
    PhoneCountryCode(dialCode: 380, isoCode: 'UA', name: 'Ukraine'),
    PhoneCountryCode(dialCode: 381, isoCode: 'RS', name: 'Serbia'),
    PhoneCountryCode(dialCode: 382, isoCode: 'ME', name: 'Montenegro'),
    PhoneCountryCode(dialCode: 383, isoCode: 'XK', name: 'Kosovo'),
    PhoneCountryCode(dialCode: 385, isoCode: 'HR', name: 'Croatia'),
    PhoneCountryCode(dialCode: 386, isoCode: 'SI', name: 'Slovenia'),
    PhoneCountryCode(
        dialCode: 387, isoCode: 'BA', name: 'Bosnia and Herzegovina'),
    PhoneCountryCode(dialCode: 389, isoCode: 'MK', name: 'North Macedonia'),
    PhoneCountryCode(dialCode: 420, isoCode: 'CZ', name: 'Czech Republic'),
    PhoneCountryCode(dialCode: 421, isoCode: 'SK', name: 'Slovakia'),
    PhoneCountryCode(dialCode: 423, isoCode: 'LI', name: 'Liechtenstein'),
    PhoneCountryCode(dialCode: 500, isoCode: 'FK', name: 'Falkland Islands'),
    PhoneCountryCode(dialCode: 501, isoCode: 'BZ', name: 'Belize'),
    PhoneCountryCode(dialCode: 502, isoCode: 'GT', name: 'Guatemala'),
    PhoneCountryCode(dialCode: 503, isoCode: 'SV', name: 'El Salvador'),
    PhoneCountryCode(dialCode: 504, isoCode: 'HN', name: 'Honduras'),
    PhoneCountryCode(dialCode: 505, isoCode: 'NI', name: 'Nicaragua'),
    PhoneCountryCode(dialCode: 506, isoCode: 'CR', name: 'Costa Rica'),
    PhoneCountryCode(dialCode: 507, isoCode: 'PA', name: 'Panama'),
    PhoneCountryCode(
        dialCode: 508, isoCode: 'PM', name: 'Saint Pierre and Miquelon'),
    PhoneCountryCode(dialCode: 509, isoCode: 'HT', name: 'Haiti'),
    PhoneCountryCode(
        dialCode: 590, isoCode: 'GP', name: 'Guadeloupe / Saint Martin'),
    PhoneCountryCode(dialCode: 591, isoCode: 'BO', name: 'Bolivia'),
    PhoneCountryCode(dialCode: 592, isoCode: 'GY', name: 'Guyana'),
    PhoneCountryCode(dialCode: 593, isoCode: 'EC', name: 'Ecuador'),
    PhoneCountryCode(dialCode: 594, isoCode: 'GF', name: 'French Guiana'),
    PhoneCountryCode(dialCode: 595, isoCode: 'PY', name: 'Paraguay'),
    PhoneCountryCode(dialCode: 596, isoCode: 'MQ', name: 'Martinique'),
    PhoneCountryCode(dialCode: 597, isoCode: 'SR', name: 'Suriname'),
    PhoneCountryCode(dialCode: 598, isoCode: 'UY', name: 'Uruguay'),
    PhoneCountryCode(
        dialCode: 599, isoCode: 'CW', name: 'Curacao / Caribbean Netherlands'),
    PhoneCountryCode(dialCode: 670, isoCode: 'TL', name: 'Timor Leste'),
    PhoneCountryCode(
        dialCode: 672, isoCode: 'NF', name: 'Norfolk Island / Antarctica'),
    PhoneCountryCode(dialCode: 673, isoCode: 'BN', name: 'Brunei'),
    PhoneCountryCode(dialCode: 674, isoCode: 'NR', name: 'Nauru'),
    PhoneCountryCode(dialCode: 675, isoCode: 'PG', name: 'Papua New Guinea'),
    PhoneCountryCode(dialCode: 676, isoCode: 'TO', name: 'Tonga'),
    PhoneCountryCode(dialCode: 677, isoCode: 'SB', name: 'Solomon Islands'),
    PhoneCountryCode(dialCode: 678, isoCode: 'VU', name: 'Vanuatu'),
    PhoneCountryCode(dialCode: 679, isoCode: 'FJ', name: 'Fiji'),
    PhoneCountryCode(dialCode: 680, isoCode: 'PW', name: 'Palau'),
    PhoneCountryCode(dialCode: 681, isoCode: 'WF', name: 'Wallis and Futuna'),
    PhoneCountryCode(dialCode: 682, isoCode: 'CK', name: 'Cook Islands'),
    PhoneCountryCode(dialCode: 683, isoCode: 'NU', name: 'Niue'),
    PhoneCountryCode(dialCode: 685, isoCode: 'WS', name: 'Samoa'),
    PhoneCountryCode(dialCode: 686, isoCode: 'KI', name: 'Kiribati'),
    PhoneCountryCode(dialCode: 687, isoCode: 'NC', name: 'New Caledonia'),
    PhoneCountryCode(dialCode: 688, isoCode: 'TV', name: 'Tuvalu'),
    PhoneCountryCode(dialCode: 689, isoCode: 'PF', name: 'French Polynesia'),
    PhoneCountryCode(dialCode: 690, isoCode: 'TK', name: 'Tokelau'),
    PhoneCountryCode(dialCode: 691, isoCode: 'FM', name: 'Micronesia'),
    PhoneCountryCode(dialCode: 692, isoCode: 'MH', name: 'Marshall Islands'),
    PhoneCountryCode(dialCode: 850, isoCode: 'KP', name: 'North Korea'),
    PhoneCountryCode(dialCode: 852, isoCode: 'HK', name: 'Hong Kong'),
    PhoneCountryCode(dialCode: 853, isoCode: 'MO', name: 'Macau'),
    PhoneCountryCode(dialCode: 855, isoCode: 'KH', name: 'Cambodia'),
    PhoneCountryCode(dialCode: 856, isoCode: 'LA', name: 'Laos'),
    PhoneCountryCode(dialCode: 880, isoCode: 'BD', name: 'Bangladesh'),
    PhoneCountryCode(dialCode: 886, isoCode: 'TW', name: 'Taiwan'),
    PhoneCountryCode(dialCode: 960, isoCode: 'MV', name: 'Maldives'),
    PhoneCountryCode(dialCode: 961, isoCode: 'LB', name: 'Lebanon'),
    PhoneCountryCode(dialCode: 962, isoCode: 'JO', name: 'Jordan'),
    PhoneCountryCode(dialCode: 963, isoCode: 'SY', name: 'Syria'),
    PhoneCountryCode(dialCode: 964, isoCode: 'IQ', name: 'Iraq'),
    PhoneCountryCode(dialCode: 965, isoCode: 'KW', name: 'Kuwait'),
    PhoneCountryCode(dialCode: 966, isoCode: 'SA', name: 'Saudi Arabia'),
    PhoneCountryCode(dialCode: 967, isoCode: 'YE', name: 'Yemen'),
    PhoneCountryCode(dialCode: 968, isoCode: 'OM', name: 'Oman'),
    PhoneCountryCode(dialCode: 970, isoCode: 'PS', name: 'Palestine'),
    PhoneCountryCode(
        dialCode: 971, isoCode: 'AE', name: 'United Arab Emirates'),
    PhoneCountryCode(dialCode: 972, isoCode: 'IL', name: 'Israel'),
    PhoneCountryCode(dialCode: 973, isoCode: 'BH', name: 'Bahrain'),
    PhoneCountryCode(dialCode: 974, isoCode: 'QA', name: 'Qatar'),
    PhoneCountryCode(dialCode: 975, isoCode: 'BT', name: 'Bhutan'),
    PhoneCountryCode(dialCode: 976, isoCode: 'MN', name: 'Mongolia'),
    PhoneCountryCode(dialCode: 977, isoCode: 'NP', name: 'Nepal'),
    PhoneCountryCode(dialCode: 992, isoCode: 'TJ', name: 'Tajikistan'),
    PhoneCountryCode(dialCode: 993, isoCode: 'TM', name: 'Turkmenistan'),
    PhoneCountryCode(dialCode: 994, isoCode: 'AZ', name: 'Azerbaijan'),
    PhoneCountryCode(dialCode: 995, isoCode: 'GE', name: 'Georgia'),
    PhoneCountryCode(dialCode: 996, isoCode: 'KG', name: 'Kyrgyzstan'),
    PhoneCountryCode(dialCode: 998, isoCode: 'UZ', name: 'Uzbekistan'),
  ];

  static String clean(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static PhoneCountryCode? countryByCode(int code) {
    for (final country in countries) {
      if (country.dialCode == code) return country;
    }
    return null;
  }

  static PhoneCountryCode? detectCountry(String digits) {
    final sorted = [...countries]
      ..sort((a, b) => b.dialCodeText.length.compareTo(a.dialCodeText.length));

    for (final country in sorted) {
      if (digits.startsWith(country.dialCodeText)) return country;
    }

    return null;
  }

  static PhoneCountryCode fallbackCountry(int code) {
    return countryByCode(code) ?? countryByCode(defaultCountryCode)!;
  }

  static InternationalPhoneResult normalize(
    String rawInput, {
    int countryCode = defaultCountryCode,
    bool required = true,
    String emptyMessage = 'Nomor telepon wajib diisi.',
  }) {
    final raw = rawInput.trim();
    final digits = clean(raw);

    if (digits.isEmpty) {
      if (!required) {
        final country = fallbackCountry(countryCode);
        return InternationalPhoneResult.success(
          phone: '',
          nationalNumber: '',
          country: country,
        );
      }

      return InternationalPhoneResult.fail(emptyMessage);
    }

    final selectedCountry = countryByCode(countryCode);
    if (selectedCountry == null) {
      return InternationalPhoneResult.fail('Kode negara tidak ditemukan');
    }

    final bool explicitInternational =
        raw.startsWith('+') || raw.startsWith('00');
    PhoneCountryCode country = selectedCountry;
    String phone;
    String nationalNumber;

    if (explicitInternational) {
      final internationalDigits =
          raw.startsWith('00') && digits.startsWith('00')
              ? digits.substring(2)
              : digits;
      final detected = detectCountry(internationalDigits);

      if (detected == null) {
        return InternationalPhoneResult.fail('Kode negara tidak ditemukan');
      }

      country = detected;
      phone = internationalDigits;
      nationalNumber =
          internationalDigits.substring(country.dialCodeText.length);
    } else if (selectedCountry.dialCode == defaultCountryCode &&
        digits.startsWith(selectedCountry.dialCodeText)) {
      phone = digits;
      nationalNumber = digits.substring(selectedCountry.dialCodeText.length);
    } else if (digits.startsWith('0')) {
      nationalNumber = digits.substring(1);
      phone = '${selectedCountry.dialCodeText}$nationalNumber';
    } else {
      nationalNumber = digits;
      phone = '${selectedCountry.dialCodeText}$digits';
    }

    if (nationalNumber.isEmpty) {
      return InternationalPhoneResult.fail('Nomor telepon tidak valid');
    }

    if (country.dialCode == defaultCountryCode) {
      if (phone.length < 10 || phone.length > 14) {
        return InternationalPhoneResult.fail('Panjang nomor tidak valid');
      }
    } else if (phone.length < 6 || phone.length > 15) {
      return InternationalPhoneResult.fail('Panjang nomor tidak valid');
    }

    return InternationalPhoneResult.success(
      phone: phone,
      nationalNumber: nationalNumber,
      country: country,
    );
  }

  static bool isValid(
    String rawInput, {
    int countryCode = defaultCountryCode,
    bool required = true,
  }) {
    return normalize(
      rawInput,
      countryCode: countryCode,
      required: required,
    ).isValid;
  }

  static String toNationalInput(
    String? rawInput, {
    int countryCode = defaultCountryCode,
  }) {
    if (rawInput == null || rawInput.trim().isEmpty) return '';

    final digits = clean(rawInput);
    if (digits.isEmpty) return '';

    final selectedCountry = fallbackCountry(countryCode);

    if (digits.startsWith(selectedCountry.dialCodeText)) {
      return digits.substring(selectedCountry.dialCodeText.length);
    }

    if (digits.startsWith('0')) {
      return digits.substring(1);
    }

    return digits;
  }
}
