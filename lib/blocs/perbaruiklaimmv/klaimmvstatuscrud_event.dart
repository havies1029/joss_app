part of 'klaimmvstatuscrud_bloc.dart';

abstract class KlaimmvstatuscrudEvents extends Equatable {
	const KlaimmvstatuscrudEvents();

	@override
	List<Object> get props => [];
}

class KlaimmvstatuscrudTambahEvent extends KlaimmvstatuscrudEvents {
	final KlaimmvstatuscrudModel record;
	const KlaimmvstatuscrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvstatuscrudUbahEvent extends KlaimmvstatuscrudEvents {
	final KlaimmvstatuscrudModel record;
	const KlaimmvstatuscrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvstatuscrudHapusEvent extends KlaimmvstatuscrudEvents {
	final String recordId;
	const KlaimmvstatuscrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class KlaimmvstatuscrudLihatEvent extends KlaimmvstatuscrudEvents {
	final String recordId;
	const KlaimmvstatuscrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

