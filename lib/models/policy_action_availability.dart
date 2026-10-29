mixin PolicyActionAvailability {
  bool get isReaktif;
  bool get isRenewal;
  bool? get canReaktif;
  String get reaktifBlockedReason;
  bool? get canRenewal;
  String get renewalBlockedReason;

  bool get effectiveCanReaktif => canReaktif ?? !isReaktif;
  bool get effectiveCanRenewal => canRenewal ?? !isRenewal;
}

bool policyBoolFromJson(Object? value, {bool fallback = false}) {
  return policyNullableBoolFromJson(value) ?? fallback;
}

bool? policyNullableBoolFromJson(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;

  switch (value.toString().trim().toLowerCase()) {
    case 'true':
    case '1':
      return true;
    case 'false':
    case '0':
      return false;
    default:
      return null;
  }
}
