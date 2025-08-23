class ChangePasswordModel {
  String oldPassword;
  String newPassword;
  ChangePasswordModel({required this.oldPassword, required this.newPassword});

  factory ChangePasswordModel.fromJson(Map<String, dynamic> data) {
    return ChangePasswordModel(
        oldPassword: data['oldPassword'] ?? '',
        newPassword: data['newPassword'] ?? '');
  }

  Map<String, dynamic> toJson() => {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  };
}
