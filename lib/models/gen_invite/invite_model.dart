// lib/models/gen_invite/invite_model.dart
class InviteModel {
  final String userId;
  final String email;
  final bool success;
  final String message;

  InviteModel({
    required this.userId,
    required this.email,
    this.success = false,
    this.message = '',
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
  };
}
