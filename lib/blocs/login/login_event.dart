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

  const LoginButtonPressed({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [email, password, rememberMe];

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password, rememberMe: $rememberMe}';
}

class LoginReset extends LoginEvent {
  const LoginReset();

  @override
  List<Object> get props => [];
}