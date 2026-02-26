part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
	const ForgotPasswordEvent();

	@override
	List<Object> get props => [];
}

class ForgotPswdRequestPinEvent extends ForgotPasswordEvent {
	final ForgotPasswordModel record;
	const ForgotPswdRequestPinEvent({required this.record});

	@override
	List<Object> get props => [record];
}


class ForgotPswdValidasiPinEmailEvent extends ForgotPasswordEvent {
	final ForgotPasswordModel record;
	final DateTime requestAt;
	const ForgotPswdValidasiPinEmailEvent({required this.record, required this.requestAt});

	@override
	List<Object> get props => [record, requestAt];
}

class ForgotPswdResetPasswordEvent extends ForgotPasswordEvent {
  final ResetPasswordModel record;
  const ForgotPswdResetPasswordEvent({required this.record});

  @override
  List<Object> get props => [record];
}


