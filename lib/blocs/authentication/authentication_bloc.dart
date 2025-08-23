import 'dart:async';

import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:equatable/equatable.dart';

import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUnauthenticated()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<RequirePinEmailVerification>(_onRequirePinEmailVerification);
    on<RequireLoginClient>((event, emit) {
      emit(AuthenticationRequireLoginClient(
          requiredFrom: event.requiredFrom, errorMsg: event.errorMsg));
    });
    on<ForgotPasword>((event, emit) {
      emit(AuthenticationForgotPassword());
    });
    on<RequireLoginUser>((event, emit) {
      emit(AuthenticationUnauthenticated());
    });
    on<UserAuthenticated>(_onUserAuthenticated);
    on<RequireRegisterClient>((event, emit) {
      emit(AuthenticationRequireRegisterClient());
    });
    on<RequirePinHPVerification>((event, emit) {
      emit(AuthenticationRequirePinHPVerification(hpno: event.hpno));
    });
    on<PhonePinVerified>((event, emit) {
      emit(AuthenticationPhonePinVerified());
    });
    on<GoogleUserAuthenticated>((event, emit) {
      debugPrint("_onLoggedIn dari Form Login Google");
      emit(AuthenticationGoogleUserAuthenticated(user: event.user));
    });
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    debugPrint("_onAppStarted");

    emit(AuthenticationPreCheckHasToken());
    String token = await userRepository.getToken();
    emit(AuthenticationPostCheckHasToken());

    debugPrint("hasToken ?");
    if (token.isNotEmpty) {
      final user = await userRepository.getUserByToken(token);

      AppData.user = user;
      AppData.userToken = token;

      //emit(AuthenticatioTokenAuthenticated(user: user));
      emit(AuthenticationAuthenticated(
          user: user, authenticatedFrom: "login_token"));

      //debugPrint("hasToken ? yes -> ${AppData.userToken}");
    } else {
      //debugPrint("hasToken ? no");
      emit(AuthenticationUnauthenticated());
      //debugPrint("hasToken ? no -> proceed");
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    debugPrint("_onLoggedIn dari Form Login Client");

    emit(AuthenticationLoading());

    //emit(AuthenticationClientAuthenticated(user: event.user));
    emit(AuthenticationAuthenticated(
        user: event.user, authenticatedFrom: "login_client"));
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await userRepository.deleteToken(id: 0);
    emit(AuthenticationUnauthenticated());
  }

  Future<void> _onRequirePinEmailVerification(RequirePinEmailVerification event,
      Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    emit(AuthenticationRequirePinEmailVerification(email: event.email));
  }

  Future<void> _onUserAuthenticated(
      UserAuthenticated event, Emitter<AuthenticationState> emit) async {
    debugPrint("_onLoggedIn dari Form Login User");

    emit(AuthenticationLoading());

    //emit(AuthenticationUserAuthenticated(user: event.user));

    emit(AuthenticationAuthenticated(
        user: event.user, authenticatedFrom: "login_user"));
  }
}
