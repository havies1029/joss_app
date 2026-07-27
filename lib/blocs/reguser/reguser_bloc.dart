import 'package:flutter/cupertino.dart';
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
    on<SetIsEmailEvent>(_onSetIsEmail);
    on<ResendOtpEvent>(onResendOtp);
    on<ClearRequestFromEvent>(_onClearRequestFrom);
    on<SetRequestFromEvent>(_onSetRequestFrom);
  }

  @override
  void onEvent(RegUserEvents event) {
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<RegUserEvents, RegUserState> transition) {
    super.onTransition(transition);
  }

  void _onClearRequestFrom(
    ClearRequestFromEvent event,
    Emitter<RegUserState> emit,
  ) {
    emit(state.copyWith(
      requestFrom: '',
      isOtpClient: false,
      isRegisterSuccess: false,
      isSaved: false,
      hasFailure: false,
      verificationFailed: false,
      errors: const [],
      sentTo: '',
      sentVia: '',
    ));
  }

  void _onSetIsEmail(SetIsEmailEvent event, Emitter<RegUserState> emit) {
    emit(state.copyWith(isEmail: event.isEmail));
  }

  void _onSetRequestFrom(
    SetRequestFromEvent event,
    Emitter<RegUserState> emit,
  ) {
    emit(state.copyWith(requestFrom: event.requestFrom));
  }

  bool _isClientLoginTokenInfo(List<String> info) {
    return info.length > 8 && info[0].isNotEmpty && info[8].isNotEmpty;
  }

  Future<bool> _tryAuthenticateClientFromTokenInfo(
    String tokeninfo,
    String authenticatedFrom,
  ) async {
    final info = tokeninfo.split(";");

    if (!_isClientLoginTokenInfo(info)) {
      return false;
    }

    try {
      final username = info[8];
      final token = Token.split(username, tokeninfo);

      final user = User(
        id: 0,
        token: token.token,
        username: username,
        nama: info[2],
        hp: info[4],
        email: info[5],
        userCabang: info[1],
        userType: "C",
        cstType: info[6],
      );

      AppData.user = user;
      AppData.userToken = user.token!;

      final userRepository = UserRepository();
      await userRepository.persistToken(userToken: user.token ?? "");

      authenticationBloc.add(
        UserRoleChanged(
          user: user,
          authenticatedFrom: authenticatedFrom,
        ),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> onTambahRegUser(
    RegUserTambahEvent event,
    Emitter<RegUserState> emit,
  ) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;

    emit(
      state.copyWith(
        isSaving: true,
        isSaved: false,
        requestFrom: event.requestFrom,
        isRegisterSuccess: false,
      ),
    );

    returnData = await repository.regUserTambah(event.record);

    final String dataString = returnData.data.toString();
    List<String> info = dataString.split(';');

    hasFailure = !returnData.success;

    if (!hasFailure && !_isClientLoginTokenInfo(info)) {
      event.record.reguserId = info.isNotEmpty ? info[0] : '';
    }

    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }

    emit(
      state.copyWith(
        isSaving: false,
        isSaved: true,
        record: event.record,
        errors: errors,
        hasFailure: hasFailure,
        sentTo: '',
        sentVia: '',
        isRegisterSuccess: !hasFailure,
        isOtpClient: false,
      ),
    );

    if (!hasFailure) {
      await _tryAuthenticateClientFromTokenInfo(dataString, event.requestFrom);
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
    ValidasiPinHPEvent event,
    Emitter<RegUserState> emit,
  ) async {
    debugPrint("OTP START - requestFrom before emit: ${state.requestFrom}");

    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      isRegisterSuccess: false,
      verificationFailed: false,
      errors: const [],
    ));

    debugPrint(
        "OTP START - requestFrom after first emit: ${state.requestFrom}");

    ReturnDataAPI returnData =
        await repository.validasiPinHP(event.record, state.requestFrom);

    final bool hasFailure = !returnData.success;
    final List<String> errors = [];

    if (hasFailure) {
      errors.add(returnData.data);
    }

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      verificationFailed: hasFailure,
      errors: errors,
      isOtpClient: !hasFailure,
      isRegisterSuccess: false,
    ));

    debugPrint(
        "OTP END - requestFrom after success/fail emit: ${state.requestFrom}");
    if (!hasFailure) {
      debugPrint(
          "OTP SUCCESS - requestFrom before UserRoleChanged: ${state.requestFrom}");

      authenticationBloc.add(PhonePinVerified());
      await _tryAuthenticateClientFromTokenInfo(
          returnData.data, state.requestFrom);
    }
  }

  Future<void> onResendOtp(
      ResendOtpEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(
        isSaving: true,
        isSaved: false,
        isResendOtp: true,
        verificationFailed: false,
        errors: const []));
    ReturnDataAPI returnData =
        await repository.regUserResendOtp(event.reguserId);
    bool hasFailure = !returnData.success;
    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }

    emit(state.copyWith(
        isSaving: false,
        isSaved: false,
        hasFailure: hasFailure,
        verificationFailed: false,
        errors: errors,
        isResendOtp: false,
        record: state.record?.copyWith(reguserId: returnData.data)));
  }
}
