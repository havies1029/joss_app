import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/reguser/reguser_model.dart';
import 'package:joss_app/repositories/reguser/reguser_repository.dart';

part 'reguser_event.dart';
part 'reguser_state.dart';

class RegUserBloc extends Bloc<RegUserEvents, RegUserState> {
  final RegUserRepository repository;
  final AuthenticationBloc authenticationBloc;
  RegUserBloc({required this.repository, required this.authenticationBloc})
      : super(const RegUserState()) {
    on<RegUserTambahEvent>(onTambahRegUser);
    on<RegUserUbahEvent>(onUbahRegUser);
    on<RegUserHapusEvent>(onHapusRegUser);
    on<RegUserLihatEvent>(onLihatRegUser);
    on<ValidasiPinHPEvent>(onValidasiPinHP);
    on<SetIsEmailRegEvent>(_onSetIsEmail);
  }

  void _onSetIsEmail(SetIsEmailRegEvent event, Emitter<RegUserState> emit) {
    emit(state.copyWith(isEmail: event.isEmail));
  }

  Future<void> onTambahRegUser(
      RegUserTambahEvent event, Emitter<RegUserState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSaving: true, isSaved: false, requestFrom: event.requestFrom));
    returnData = await repository.regUserTambah(event.record);
    final String dataString = returnData.data.toString();
    List<String> info = dataString.split(';');
    event.record.reguserId = info.isNotEmpty ? info[0] : '';
    hasFailure = !returnData.success;
    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }
    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        record: event.record,
        errors: errors,
        hasFailure: hasFailure));

    if (!hasFailure) {
        authenticationBloc
            .add(RequirePinHPVerification(hpno: event.record.telepon));
    }
  }

  Future<void> onUbahRegUser(
      RegUserUbahEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.regUserUbah(event.record);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onHapusRegUser(
      RegUserHapusEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.regUserHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatRegUser(
      RegUserLihatEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    RegUserModel record = await repository.regUserLihat(event.recordId);
    emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
  }

  Future<void> onValidasiPinHP(
      ValidasiPinHPEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    ReturnDataAPI returnData = await repository.validasiPinHP(event.record, state.requestFrom);
    bool hasFailure = !returnData.success;
    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }
    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      verificationFailed: hasFailure,
      errors: errors,
    ));

    if (!hasFailure) {
      authenticationBloc.add(PhonePinVerified());

      String tokeninfo = returnData.data;
      List<String> info = tokeninfo.split(";");
      String username = info[8];
      Token token = Token.split(username, tokeninfo);
      User user = User(
          id: 0,
          token: token.token,
          username: username,
          nama: info[2],
          email: info[5],
          userCabang: info[1],
          userType: "C",);

      AppData.user = user;
      AppData.userToken = user.token!;

      UserRepository userRepository = UserRepository();
      userRepository.persistToken(userToken: user.token ?? "");
      
      authenticationBloc.add(UserRoleChanged(user: user, authenticatedFrom: state.requestFrom));

    }
  }
}
