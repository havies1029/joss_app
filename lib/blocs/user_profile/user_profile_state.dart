// import 'dart:typed_data';
//
// class UserProfileState {
//   final String? mrekan1Id;
//   final String? nama;
//   final Uint8List? fotoBytes;
//   final String? email;
//   final String? telepon;
//   final String? mjnsclientId;
//
//   const UserProfileState({
//     this.mrekan1Id,
//     this.nama,
//     this.fotoBytes,
//     this.email,
//     this.telepon,
//     this.mjnsclientId,
//   });
//
//   UserProfileState copyWith({
//     String? mrekan1Id,
//     String? nama,
//     Uint8List? fotoBytes,
//     String? email,
//     String? telepon,
//     String? mjnsclientId,
//   }) {
//     return UserProfileState(
//       mrekan1Id : mrekan1Id ?? this.mrekan1Id,
//       nama: nama ?? this.nama,
//       fotoBytes: fotoBytes ?? this.fotoBytes,
//       email: email ?? this.email,
//       telepon: telepon ?? this.telepon,
//       mjnsclientId: mjnsclientId ?? this.mjnsclientId,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'mrekan1Id': mrekan1Id,
//       'nama': nama,
//       'fotoBytes': fotoBytes != null ? fotoBytes!.toList() : null,
//       'email': email,
//       'telepon': telepon,
//       'mjnsclientId': mjnsclientId,
//     };
//   }
//
//   factory UserProfileState.fromJson(Map<String, dynamic> json) {
//     return UserProfileState(
//       mrekan1Id: json['mrekan1Id'] as String?,
//       nama: json['nama'] as String?,
//       fotoBytes: json['fotoBytes'] != null
//           ? Uint8List.fromList(List<int>.from(json['fotoBytes']))
//           : null,
//       email: json['email'] as String?,
//       telepon: json['telepon'] as String?,
//       mjnsclientId: json['mjnsclientId'] as String?,
//     );
//   }
// }
