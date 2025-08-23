class EmailVerificationModel {
  String? requestId = '';
  String email;
  String? pin;
  String? requestFrom;

  EmailVerificationModel({required this.email, this.pin, this.requestId, this.requestFrom});

  factory EmailVerificationModel.fromJson(Map<String, dynamic> data) {
    return EmailVerificationModel(
      email: data['email'] ?? '',
      pin: data['pin'] ?? '',
      requestId: data['requestId'] ?? '',
      requestFrom: data['requestFrom'] ?? '',

    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'pin': pin,
        'requestId': requestId,
        'requestFrom': requestFrom,
      };
}
