class ForgotPasswordModel {
  String? requestId = '';
  String email;
  String? pin;
  String? requestFrom;

  ForgotPasswordModel({required this.email, this.pin, this.requestId, this.requestFrom});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> data) {
    return ForgotPasswordModel(
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
