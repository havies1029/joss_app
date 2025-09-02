import 'dart:typed_data';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserProfileState {
  final String? nama;
  final Uint8List? fotoBytes;
  final String? email;
  final String? telepon;

  const UserProfileState({
    this.nama,
    this.fotoBytes,
    this.email,
    this.telepon,
  });

  UserProfileState copyWith({
    String? nama,
    Uint8List? fotoBytes,
    String? email,
    String? telepon,
  }) {
    return UserProfileState(
      nama: nama ?? this.nama,
      fotoBytes: fotoBytes ?? this.fotoBytes,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'fotoBytes': fotoBytes != null ? fotoBytes!.toList() : null,
      'email': email,
      'telepon': telepon,
    };
  }

  factory UserProfileState.fromJson(Map<String, dynamic> json) {
    return UserProfileState(
      nama: json['nama'] as String?,
      fotoBytes: json['fotoBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['fotoBytes']))
          : null,
      email: json['email'] as String?,
      telepon: json['telepon'] as String?,
    );
  }
}


class UserProfileCubit extends HydratedCubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileState());

  void setProfile({String? nama, String? email, String? telepon, Uint8List? fotoBytes}) {
    emit(state.copyWith(
      nama: nama,
      email: email,
      telepon: telepon,
      fotoBytes: fotoBytes,
    ));
  }

  void clearProfile() {
    emit(const UserProfileState());
  }

  @override
  UserProfileState? fromJson(Map<String, dynamic> json) =>
      UserProfileState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserProfileState state) => state.toJson();
}
