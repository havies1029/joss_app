part of 'reguser_bloc.dart';

abstract class RegUserEvents extends Equatable {
	const RegUserEvents();

	@override
	List<Object> get props => [];
}

class RegUserTambahEvent extends RegUserEvents {
	final RegUserModel record;
  final String requestFrom;
	const RegUserTambahEvent({required this.record, required this.requestFrom});

	@override
	List<Object> get props => [record, requestFrom];
}

class RegUserUbahEvent extends RegUserEvents {
	final RegUserModel record;
	const RegUserUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RegUserHapusEvent extends RegUserEvents {
	final String recordId;
	const RegUserHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RegUserLihatEvent extends RegUserEvents {
	final String recordId;
	const RegUserLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ValidasiPinHPEvent extends RegUserEvents {
	final RegUserModel record;
	const ValidasiPinHPEvent({required this.record});

	@override
	List<Object> get props => [record];
}


