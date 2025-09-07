import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'reguser_profile_state.dart';

class RegUserProfileCubit extends HydratedCubit<RegUserProfileState> {
  RegUserProfileCubit() : super(const RegUserProfileState());

  void setProfile({
    String? email,
  }) {
    emit(state.copyWith(
      email: email,
    ));
  }

  void clearProfile() {
    clear(); // hapus cache HydratedBloc
    emit(const RegUserProfileState());
  }

  @override
  RegUserProfileState? fromJson(Map<String, dynamic> json) =>
      RegUserProfileState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(RegUserProfileState state) => state.toJson();
}
