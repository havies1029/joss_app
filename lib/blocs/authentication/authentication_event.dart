part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;

  const LoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {}

class RequireLoginClient extends AuthenticationEvent {
  final String requiredFrom;
  final String errorMsg;

  const RequireLoginClient({required this.requiredFrom, required this.errorMsg});

  @override
  List<Object> get props => [requiredFrom, errorMsg];
}

class RequireLoginUser extends AuthenticationEvent {}

class RequirePinEmailVerification extends AuthenticationEvent {
  final String email;

  const RequirePinEmailVerification({required this.email});

  @override
  List<Object> get props => [email];
}

class FailedVerifyPinEmail extends AuthenticationEvent {}

class RequirePinHPVerification extends AuthenticationEvent {
  final String hpno;

  const RequirePinHPVerification({required this.hpno});

  @override
  List<Object> get props => [hpno];
}

class ForgotPasword extends AuthenticationEvent {
  final String email;

  const ForgotPasword({required this.email});

  @override
  List<Object> get props => [email];
}

class UserAuthenticated extends AuthenticationEvent {
  final User user;
  final String authenticatedFrom;

  const UserAuthenticated({required this.user, required this.authenticatedFrom});

  @override
  List<Object> get props => [user, authenticatedFrom];
}

class GoogleUserAuthenticated extends AuthenticationEvent {
  final GoogleSignInAccount user;

  const GoogleUserAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class RequireRegisterClient extends AuthenticationEvent {
  final String requiredFrom;
  const RequireRegisterClient({required this.requiredFrom});
  @override
  List<Object> get props => [requiredFrom];
}

class PhonePinVerified extends AuthenticationEvent {}

class UserRoleChanged extends AuthenticationEvent {
  final User user;
  final String authenticatedFrom;

  const UserRoleChanged({required this.user, required this.authenticatedFrom});
  
  @override
  List<Object> get props => [user, authenticatedFrom];
}
