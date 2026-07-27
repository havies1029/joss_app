import 'dart:async';
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
    emailVerificationBloc
        .add(const FieldEmailVerificationChangedEvent(email: ''));
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    //debugPrint('BLOC -> _onLoginButtonPressed START');
    if (state is LoginLoading) return;

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
        userRepository.persistToken(userToken: user.token ?? "");
      }

      _clearEmailVerificationState();

      final authenticatedFrom = event.requestFrom.trim().isEmpty
          ? 'login_client'
          : event.requestFrom.trim();

      authenticationBloc.add(
        LoggedIn(
          user: user,
          authenticatedFrom: authenticatedFrom,
        ),
      );
      emit(LoginPostAuthenticate());
    } catch (error) {
      emit(LoginFailure(error: "username atau password salah"));
    }
  }
}
