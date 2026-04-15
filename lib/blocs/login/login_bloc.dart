import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

import 'emailverification_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final EmailVerificationBloc emailVerificationBloc;

  LoginBloc({
    required this.userRepository,
    required this.authenticationBloc,
    required this.emailVerificationBloc,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoginReset>((event, emit) => emit(LoginInitial()));
    //on<PinVerified>(_onPinVerified);
  }

  void _clearEmailVerificationState() {
    emailVerificationBloc.add(const FieldEmailVerificationChangedEvent(email: ''));
  }
  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginInitial());
    emit(LoginLoading());

    try {
      final user = await userRepository.authenticate(
        email: event.email,
        password: event.password,
      );

      AppData.user = user;
      AppData.userToken = user.token!;

      emit(LoginPreAuthenticate());

      if (event.rememberMe) {
        await userRepository.persistToken(userToken: user.token ?? "");
      } else {
      }

      _clearEmailVerificationState();

      debugPrint("Dispatch LoggedIn to AuthenticationBloc");
      authenticationBloc.add(LoggedIn(user: user));

      emit(LoginPostAuthenticate());
    } catch (error, stackTrace) {
      debugPrint("===== LOGIN ERROR =====");
      debugPrint("Error: $error");
      debugPrint("StackTrace: $stackTrace");

      emit(LoginFailure(error: "username atau password salah"));
    }
  }
}