part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class UserChangePasswordEvent extends ChangePasswordEvent {
	final ChangePasswordModel pswd;
	const UserChangePasswordEvent({required this.pswd});

	@override
	List<Object> get props => [pswd];
}
