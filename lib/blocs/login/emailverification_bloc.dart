import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/login/emailverification_model.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';

part 'emailverification_event.dart';
part 'emailverification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvents, EmailVerificationState> {
  final EmailVerificationRepository repository;
  final AuthenticationBloc authenticationBloc;

  EmailVerificationBloc(
      {required this.repository, required this.authenticationBloc})
      : super(const EmailVerificationState()) {
    on<EmailVerificationTambahEvent>(onTambahEmailVerification);
    on<ValidasiPinEmailEvent>(onValidasiPinEmail);
    on<FieldSimpanPasswordChangedEvent>(onFieldSimpanPasswordChangedEvent);
    on<FieldEmailVerificationChangedEvent>(onFieldEmailVerificationChangedEvent);
    on<FieldTeleponVerificationChangedEvent>(onFieldTeleponVerificationChangedEvent);

  }

  Future<void> onFieldEmailVerificationChangedEvent(
      FieldEmailVerificationChangedEvent event,
      Emitter<EmailVerificationState> emit,
      ) async {
    emit(state.copyWith(
      email: event.email.trim(),
      telepon: '',
    ));
  }

  Future<void> onFieldTeleponVerificationChangedEvent(
      FieldTeleponVerificationChangedEvent event,
      Emitter<EmailVerificationState> emit,
      ) async {
    emit(state.copyWith(
      telepon: event.telepon.trim(),
      email: '',
    ));
  }


  Future<void> onTambahEmailVerification(EmailVerificationTambahEvent event,
      Emitter<EmailVerificationState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isLoading: true, isLoaded: false, hasFailure: false));
    returnData = await repository.emailVerificationTambah(event.record);
    hasFailure = !returnData.success;
    List<String> errors = [];

    if (!hasFailure) {
      List<String> infoData = returnData.data.split(";");

      if ((infoData[0] == '1') || (infoData[0] == '3')) {
        // Token token = Token.split(event.record.email, infoData[1]);
        Token token = Token.split(infoData[2], infoData[1]);

        UserRepository userRepository = UserRepository();

        User user = User(
          id: 0,
          // username: event.record.email,
          username: infoData[2],
          email: event.record.email,
          token: token.token,
          userType: 'U',
        );

        AppData.user = user;
        AppData.userToken = token.token!;

        if (state.isSimpanPassword) {
          userRepository.persistToken(userToken: token.token!);
        }

        authenticationBloc.add(UserAuthenticated(user: user, authenticatedFrom: "email_verification"));
      } else if (infoData[0] == '2') {
        event.record.requestId = infoData[1];
        authenticationBloc
            .add(RequirePinEmailVerification(email: event.record.email));
      }
    } else if (returnData.data.isNotEmpty) {
      List<String> infoData = returnData.data.split(";");
      if (infoData[0] == '9') {
        errors.add(infoData[1]);

        authenticationBloc.add(RequireLoginClient(
            requiredFrom: "bloc_email_verification", errorMsg: infoData[1]));
      }
    }

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      hasFailure: hasFailure,
      record: event.record,
      errors: errors,
    ));
  }

  Future<void> onValidasiPinEmail(
      ValidasiPinEmailEvent event, Emitter<EmailVerificationState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(
        isLoading: true, isLoaded: false, verificationFailed: false));
    event.record.requestId = state.record?.requestId ?? '';
    returnData = await repository.validasiPinEmail(event.record);

    debugPrint("onValidasiPinEmail returnData: ${returnData.data}");

    hasFailure = !returnData.success;
    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      hasFailure: hasFailure,
    ));

    if (!hasFailure && returnData.data.isNotEmpty) {

      List<String> info = returnData.data.split(";");
      Token token = Token.split(info[0], info[1]);

      UserRepository userRepository = UserRepository();

      User user = User(
        id: 0,
        username: info[0],
        email: event.record.email,
        token: token.token,
      );

      AppData.user = user;
      AppData.userToken = token.token!;

      if (state.isSimpanPassword) {
        userRepository.persistToken(userToken: token.token!);
      }

      authenticationBloc.add(UserAuthenticated(user: user, authenticatedFrom: "email_verification"));
    } else {
      List<String> errors = [];
      errors.add(returnData.data);
      emit(state.copyWith(verificationFailed: true, errors: errors));
    }
  }

  Future<void> onFieldSimpanPasswordChangedEvent(
      FieldSimpanPasswordChangedEvent event,
      Emitter<EmailVerificationState> emit) async {
    debugPrint(
        "onFieldSimpanPasswordChangedEvent event: ${event.isSimpanPassword}");
    emit(state.copyWith(isSimpanPassword: event.isSimpanPassword));

    debugPrint(
        "onFieldSimpanPasswordChangedEvent state: ${state.isSimpanPassword}");
  }
}
