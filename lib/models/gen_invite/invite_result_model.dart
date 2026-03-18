class InviteResultModel {
  final bool success;
  final String message;
  final String? link;

  InviteResultModel({
    required this.success,
    required this.message,
    this.link,
  });

  factory InviteResultModel.fromJson(Map<String, dynamic> json) {
    return InviteResultModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      link: json['link']?.toString(),
    );
  }
}