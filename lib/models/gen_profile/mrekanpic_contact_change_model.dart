class MRekanPicContactChangeType {
  static const int email = 10;
  static const int phone = 20;
}

class MRekanPicContactVerifyVia {
  static const int email = 10;
  static const int phone = 20;
}

class MRekanPicContactChangeStatus {
  static const int pending = 10;
  static const int verified = 20;
  static const int readyToApply = 25;
  static const int completed = 30;
  static const int expired = 40;
  static const int cancelled = 50;
}

class MRekanPicContactChangeSendModel {
  final String mrekanpicId;
  final int changeTypeId;
  final int verifyViaId;

  const MRekanPicContactChangeSendModel({
    required this.mrekanpicId,
    required this.changeTypeId,
    required this.verifyViaId,
  });

  Map<String, dynamic> toJson() => {
        'mrekanpicId': mrekanpicId,
        'changeTypeId': changeTypeId,
        'verifyViaId': verifyViaId,
      };
}

class MRekanPicContactChangeValidateModel {
  final String changeRequestId;
  final String pin;

  const MRekanPicContactChangeValidateModel({
    required this.changeRequestId,
    required this.pin,
  });

  Map<String, dynamic> toJson() => {
        'changeRequestId': changeRequestId,
        'pin': pin,
      };
}

class MRekanPicContactChangePrepareModel {
  final String changeRequestId;
  final String newValue;

  const MRekanPicContactChangePrepareModel({
    required this.changeRequestId,
    required this.newValue,
  });

  Map<String, dynamic> toJson() => {
        'changeRequestId': changeRequestId,
        'newValue': newValue,
      };
}

class MRekanPicPreparedContactChange {
  final String changeRequestId;
  final String newValue;

  const MRekanPicPreparedContactChange({
    required this.changeRequestId,
    required this.newValue,
  });
}

class MRekanPicContactChangeResult {
  final bool success;
  final String data;
  final String message;
  final int rowcount;
  final String changeRequestId;
  final int? statusId;
  final int? changeTypeId;
  final int? verifyViaId;
  final String maskedTarget;
  final DateTime? otpExpiresAt;
  final DateTime? authorizationExpiresAt;
  final int? remainingAttempts;

  const MRekanPicContactChangeResult({
    required this.success,
    required this.data,
    required this.message,
    required this.rowcount,
    this.changeRequestId = '',
    this.statusId,
    this.changeTypeId,
    this.verifyViaId,
    this.maskedTarget = '',
    this.otpExpiresAt,
    this.authorizationExpiresAt,
    this.remainingAttempts,
  });

  String get effectiveMessage => message.trim().isNotEmpty ? message : data;

  factory MRekanPicContactChangeResult.fromJson(Map<String, dynamic> json) {
    return MRekanPicContactChangeResult(
      success: json['success'] == true,
      data: json['data']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      rowcount: _asInt(json['rowcount']) ?? 0,
      changeRequestId: json['changeRequestId']?.toString() ?? '',
      statusId: _asInt(json['statusId']),
      changeTypeId: _asInt(json['changeTypeId']),
      verifyViaId: _asInt(json['verifyViaId']),
      maskedTarget: json['maskedTarget']?.toString() ?? '',
      otpExpiresAt: _asDateTime(json['otpExpiresAt']),
      authorizationExpiresAt: _asDateTime(json['authorizationExpiresAt']),
      remainingAttempts: _asInt(json['remainingAttempts']),
    );
  }

  factory MRekanPicContactChangeResult.failure(String message) {
    return MRekanPicContactChangeResult(
      success: false,
      data: message,
      message: message,
      rowcount: 0,
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
