import 'dart:typed_data';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends HydratedCubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileState());

  void setProfile({
    String? nama,
    String? email,
    String? telepon,
    Uint8List? fotoBytes,
    String? mjnsclientId,
  }) {
    emit(state.copyWith(
      nama: nama,
      email: email,
      telepon: telepon,
      fotoBytes: fotoBytes,
      mjnsclientId: mjnsclientId,
    ));
  }

  void clearProfile() {
    clear(); // clear hydrated storage
    emit(const UserProfileState());
  }

  @override
  UserProfileState? fromJson(Map<String, dynamic> json) =>
      UserProfileState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserProfileState state) => state.toJson();
}
