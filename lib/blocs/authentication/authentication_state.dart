part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;
  final String authenticatedFrom;
  AuthenticationAuthenticated({required this.user, required this.authenticatedFrom});
  @override
  List<Object> get props => [user, authenticatedFrom];
}

class AuthenticationGoogleUserAuthenticated extends AuthenticationState {
  final GoogleSignInAccount user;
  AuthenticationGoogleUserAuthenticated({required this.user});
  @override
  List<Object> get props => [user];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationPreCheckHasToken extends AuthenticationState {}

class AuthenticationPostCheckHasToken extends AuthenticationState {}

class AuthenticationRequirePinEmailVerification extends AuthenticationState {
  final String email;

  AuthenticationRequirePinEmailVerification({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthenticationRequireLoginClient extends AuthenticationState {
  final String requiredFrom;
  final String errorMsg;

  AuthenticationRequireLoginClient(
      {required this.requiredFrom, required this.errorMsg});

  @override
  List<Object> get props => [requiredFrom, errorMsg];
}

class AuthenticationRequirePinHPVerification extends AuthenticationState {
  final String hpno;

  AuthenticationRequirePinHPVerification({required this.hpno});

  @override
  List<Object> get props => [hpno];
}

class AuthenticationForgotPassword extends AuthenticationState {}

class AuthenticationRequireRegisterClient extends AuthenticationState {
  final String requiredFrom;
  AuthenticationRequireRegisterClient({required this.requiredFrom});
  @override
  List<Object> get props => [requiredFrom];
}

class AuthenticationPhonePinVerified extends AuthenticationState {}

class AuthenticationUserRoleChanged extends AuthenticationState {}
