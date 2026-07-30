class RegparValidationPreviewRequestModel {
  String regpar1Id;
  String? rokupasiId;
  String? currId;
  double siBuilding;
  double siMachinery;
  double siContent;
  double siStock;
  double siOther;

  RegparValidationPreviewRequestModel({
    required this.regpar1Id,
    this.rokupasiId,
    this.currId,
    required this.siBuilding,
    required this.siMachinery,
    required this.siContent,
    required this.siStock,
    required this.siOther,
  });

  Map<String, dynamic> toJson() => {
        'regpar1Id': regpar1Id,
        'rokupasiId': rokupasiId,
        'currId': currId,
        'siBuilding': siBuilding.toString(),
        'siMachinery': siMachinery.toString(),
        'siContent': siContent.toString(),
        'siStock': siStock.toString(),
        'siOther': siOther.toString(),
      };
}

class RegparValidationPreviewIssueModel {
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

  RegparValidationPreviewIssueModel({
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

  factory RegparValidationPreviewIssueModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return RegparValidationPreviewIssueModel(
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

class RegparValidationPreviewResponseModel {
  bool success;
  bool hasIssue;
  String propertyLabel;
  List<RegparValidationPreviewIssueModel> issues;

  RegparValidationPreviewResponseModel({
    required this.success,
    required this.hasIssue,
    required this.propertyLabel,
    required this.issues,
  });

  factory RegparValidationPreviewResponseModel.fromJson(
    Map<String, dynamic> data,
  ) {
    final rawIssues = data['issues'];
    return RegparValidationPreviewResponseModel(
      success: data['success'] ?? false,
      hasIssue: data['hasIssue'] ?? false,
      propertyLabel: data['propertyLabel']?.toString() ?? '',
      issues: rawIssues is List
          ? rawIssues
              .whereType<Map<String, dynamic>>()
              .map(RegparValidationPreviewIssueModel.fromJson)
              .toList()
          : <RegparValidationPreviewIssueModel>[],
    );
  }

  factory RegparValidationPreviewResponseModel.failure() {
    return RegparValidationPreviewResponseModel(
      success: false,
      hasIssue: false,
      propertyLabel: '',
      issues: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'hasIssue': hasIssue,
        'propertyLabel': propertyLabel,
        'issues': issues.map((e) => e.toJson()).toList(),
      };
}
