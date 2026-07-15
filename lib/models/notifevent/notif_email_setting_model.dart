class NotifEmailSettingModel {
  final String userId;
  final bool isNotifEmail;

  const NotifEmailSettingModel({
    required this.userId,
    required this.isNotifEmail,
  });

  factory NotifEmailSettingModel.fromJson(Map<String, dynamic> json) {
    return NotifEmailSettingModel(
      userId: json['userid'] ?? '',
      isNotifEmail: json['isnotifemail'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'isnotifemail': isNotifEmail,
    };
  }
}
