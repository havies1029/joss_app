part of 'emailverification_bloc.dart';

abstract class EmailVerificationEvents extends Equatable {
	const EmailVerificationEvents();

	@override
	List<Object> get props => [];
}

class EmailVerificationTambahEvent extends EmailVerificationEvents {
	final EmailVerificationModel record;
	const EmailVerificationTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}


class ValidasiPinEmailEvent extends EmailVerificationEvents {
	final EmailVerificationModel record;
	const ValidasiPinEmailEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class FieldSimpanPasswordChangedEvent extends EmailVerificationEvents {
	final bool isSimpanPassword;
	const FieldSimpanPasswordChangedEvent({required this.isSimpanPassword});

	@override
	List<Object> get props => [isSimpanPassword];
}

class FieldEmailVerificationChangedEvent extends EmailVerificationEvents {
	final String email;
	const FieldEmailVerificationChangedEvent({required this.email});

	@override
	List<Object> get props => [email];
}

class FieldTeleponVerificationChangedEvent extends EmailVerificationEvents {
	final String telepon;
	const FieldTeleponVerificationChangedEvent({required this.telepon});

	@override
	List<Object> get props => [telepon];
}

class SetIsEmailEvent extends EmailVerificationEvents {
	final String isEmail;

	const SetIsEmailEvent({required this.isEmail});

	@override
	List<Object> get props => [isEmail];
}

class SetIsTeleponEvent extends EmailVerificationEvents {
	final String isTelepon;

	const SetIsTeleponEvent({required this.isTelepon});

	@override
	List<Object> get props => [isTelepon];
}

