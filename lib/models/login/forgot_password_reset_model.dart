class ForgotPasswordOtpSendModel {
  final String target;
  final String requestFrom;

  const ForgotPasswordOtpSendModel({
    required this.target,
    this.requestFrom = 'email',
  });

  factory ForgotPasswordOtpSendModel.fromJson(Map<String, dynamic> data) {
    return ForgotPasswordOtpSendModel(
      target: data['target'] ?? '',
      requestFrom: data['requestFrom'] ?? 'email',
    );
  }

  Map<String, dynamic> toJson() => {
        'target': target,
        'requestFrom': requestFrom,
      };
}

class ForgotPasswordOtpValidateModel {
  final String requestId;
  final String target;
  final String requestFrom;
  final String pin;

  const ForgotPasswordOtpValidateModel({
    required this.requestId,
    required this.target,
    this.requestFrom = 'email',
    required this.pin,
  });

  factory ForgotPasswordOtpValidateModel.fromJson(Map<String, dynamic> data) {
    return ForgotPasswordOtpValidateModel(
      requestId: data['requestId'] ?? '',
      target: data['target'] ?? '',
      requestFrom: data['requestFrom'] ?? 'email',
      pin: data['pin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'target': target,
        'requestFrom': requestFrom,
        'pin': pin,
      };
}

class ForgotPasswordResetModel {
  final String requestId;
  final String target;
  final String requestFrom;
  final String newPassword;

  const ForgotPasswordResetModel({
    required this.requestId,
    required this.target,
    this.requestFrom = 'email',
    required this.newPassword,
  });

  factory ForgotPasswordResetModel.fromJson(Map<String, dynamic> data) {
    return ForgotPasswordResetModel(
      requestId: data['requestId'] ?? '',
      target: data['target'] ?? '',
      requestFrom: data['requestFrom'] ?? 'email',
      newPassword: data['newPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'target': target,
        'requestFrom': requestFrom,
        'newPassword': newPassword,
      };
}
