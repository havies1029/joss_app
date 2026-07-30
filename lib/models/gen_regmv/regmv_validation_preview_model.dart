class RegmvValidationPreviewRequestModel {
  String regmv1Id;
  DateTime polisMulai;
  DateTime polisAkhir;
  String? mmvjnscoverId;
  String? currId;
  bool isSrcc;
  bool isFlood;
  bool isEq;
  bool isTerrorism;
  bool isTbod;
  bool isAw;
  double tpl;
  double pad;
  double pap;
  double pll;
  int passangerCount;
  String? mwilayahId;
  String platNo;
  String? mmvmerkId;
  String? mmvtipeId;
  String? mmvmodelId;
  String? mwarnaId;
  int thnBuat;
  String? mmvpakaiId;
  double harga;

  RegmvValidationPreviewRequestModel({
    required this.regmv1Id,
    required this.polisMulai,
    required this.polisAkhir,
    this.mmvjnscoverId,
    this.currId,
    required this.isSrcc,
    required this.isFlood,
    required this.isEq,
    required this.isTerrorism,
    required this.isTbod,
    required this.isAw,
    required this.tpl,
    required this.pad,
    required this.pap,
    required this.pll,
    required this.passangerCount,
    this.mwilayahId,
    required this.platNo,
    this.mmvmerkId,
    this.mmvtipeId,
    this.mmvmodelId,
    this.mwarnaId,
    required this.thnBuat,
    this.mmvpakaiId,
    required this.harga,
  });

  Map<String, dynamic> toJson() => {
        'regmv1Id': regmv1Id,
        'polisMulai': polisMulai.toIso8601String(),
        'polisAkhir': polisAkhir.toIso8601String(),
        'mmvjnscoverId': mmvjnscoverId,
        'currId': currId,
        'isSrcc': isSrcc,
        'isFlood': isFlood,
        'isEq': isEq,
        'isTerrorism': isTerrorism,
        'isTbod': isTbod,
        'isAw': isAw,
        'tpl': tpl.toString(),
        'pad': pad.toString(),
        'pap': pap.toString(),
        'pll': pll.toString(),
        'passangerCount': passangerCount.toString(),
        'mwilayahId': mwilayahId,
        'platNo': platNo,
        'mmvmerkId': mmvmerkId,
        'mmvtipeId': mmvtipeId,
        'mmvmodelId': mmvmodelId,
        'mwarnaId': mwarnaId,
        'thnBuat': thnBuat.toString(),
        'mmvpakaiId': mmvpakaiId,
        'harga': harga.toString(),
      };
}

class RegmvValidationPreviewIssueModel {
  bool hasError;
  String code;
  String section;
  String fieldKey;
  String message;
  String suggestion;
  String expectedText;
  String expectedValue;
  String minValue;
  String maxValue;
  String safeValue;

  RegmvValidationPreviewIssueModel({
    required this.hasError,
    required this.code,
    required this.section,
    required this.fieldKey,
    required this.message,
    required this.suggestion,
    required this.expectedText,
    required this.expectedValue,
    required this.minValue,
    required this.maxValue,
    required this.safeValue,
  });

  factory RegmvValidationPreviewIssueModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return RegmvValidationPreviewIssueModel(
      hasError: data['hasError'] ?? false,
      code: data['code']?.toString() ?? '',
      section: data['section']?.toString() ?? '',
      fieldKey: data['fieldKey']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      suggestion: data['suggestion']?.toString() ?? '',
      expectedText: data['expectedText']?.toString() ?? '',
      expectedValue: data['expectedValue']?.toString() ?? '',
      minValue: data['minValue']?.toString() ?? '',
      maxValue: data['maxValue']?.toString() ?? '',
      safeValue: data['safeValue']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'hasError': hasError,
        'code': code,
        'section': section,
        'fieldKey': fieldKey,
        'message': message,
        'suggestion': suggestion,
        'expectedText': expectedText,
        'expectedValue': expectedValue,
        'minValue': minValue,
        'maxValue': maxValue,
        'safeValue': safeValue,
      };
}

class RegmvValidationPreviewResponseModel {
  bool success;
  bool hasIssue;
  String vehicleLabel;
  List<RegmvValidationPreviewIssueModel> issues;

  RegmvValidationPreviewResponseModel({
    required this.success,
    required this.hasIssue,
    required this.vehicleLabel,
    required this.issues,
  });

  factory RegmvValidationPreviewResponseModel.fromJson(
    Map<String, dynamic> data,
  ) {
    final rawIssues = data['issues'];
    return RegmvValidationPreviewResponseModel(
      success: data['success'] ?? false,
      hasIssue: data['hasIssue'] ?? false,
      vehicleLabel: data['vehicleLabel']?.toString() ?? '',
      issues: rawIssues is List
          ? rawIssues
              .whereType<Map<String, dynamic>>()
              .map(RegmvValidationPreviewIssueModel.fromJson)
              .toList()
          : <RegmvValidationPreviewIssueModel>[],
    );
  }

  factory RegmvValidationPreviewResponseModel.failure() {
    return RegmvValidationPreviewResponseModel(
      success: false,
      hasIssue: false,
      vehicleLabel: '',
      issues: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'hasIssue': hasIssue,
        'vehicleLabel': vehicleLabel,
        'issues': issues.map((e) => e.toJson()).toList(),
      };
}
