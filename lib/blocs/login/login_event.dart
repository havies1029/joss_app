part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;
  final String requestFrom;

  const LoginButtonPressed({
    required this.email,
    required this.password,
    required this.rememberMe,
    this.requestFrom = '',
  });

  @override
  List<Object> get props => [email, password, rememberMe, requestFrom];

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password, rememberMe: $rememberMe, requestFrom: $requestFrom}';
}

class LoginReset extends LoginEvent {
  const LoginReset();

  @override
  List<Object> get props => [];
}
