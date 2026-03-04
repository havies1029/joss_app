part of 'guestscrud_bloc.dart';

abstract class GuestsCrudEvents extends Equatable {
	const GuestsCrudEvents();

	@override
	List<Object> get props => [];
}

class GuestsCrudTambahEvent extends GuestsCrudEvents {
	final GuestsCrudModel record;
	const GuestsCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class GuestsCrudUbahEvent extends GuestsCrudEvents {
	final GuestsCrudModel record;
	const GuestsCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class GuestsCrudHapusEvent extends GuestsCrudEvents {
	final String recordId;
	const GuestsCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class GuestsCrudLihatEvent extends GuestsCrudEvents {
	final String recordId;
	const GuestsCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

