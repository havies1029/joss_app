import 'dart:typed_data';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserProfileState {
  final String? nama;
  final Uint8List? fotoBytes;

  const UserProfileState({this.nama, this.fotoBytes});

  UserProfileState copyWith({String? nama, Uint8List? fotoBytes}) {
    return UserProfileState(
      nama: nama ?? this.nama,
      fotoBytes: fotoBytes ?? this.fotoBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'fotoBytes': fotoBytes != null ? fotoBytes!.toList() : null,
    };
  }

  factory UserProfileState.fromJson(Map<String, dynamic> json) {
    return UserProfileState(
      nama: json['nama'] as String?,
      fotoBytes: json['fotoBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['fotoBytes']))
          : null,
    );
  }
}

class UserProfileCubit extends HydratedCubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileState());

  void setProfile({String? nama, Uint8List? fotoBytes}) {
    emit(state.copyWith(nama: nama, fotoBytes: fotoBytes));
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
