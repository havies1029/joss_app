// lib/models/gen_invite/invite_model.dart
class InviteModel {
  final String mrekanpicId;
  final String nama;
  final String email;

  InviteModel({
    required this.mrekanpicId,
    required this.nama,
    required this.email,  
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      mrekanpicId: json['mrekanpicId'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'mrekanpicId': mrekanpicId,
    'nama': nama,
    'email': email,
  };
}
