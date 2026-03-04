class ResetPasswordModel {
  String requestId;
  String newPassword;
  ResetPasswordModel({required this.requestId, required this.newPassword});

  factory ResetPasswordModel.fromJson(Map<String, dynamic> data) {
    return ResetPasswordModel(
        requestId: data['requestId'] ?? '',
        newPassword: data['newPassword'] ?? '');
  }

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'newPassword': newPassword,
  };
}
