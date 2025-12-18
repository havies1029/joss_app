part of 'pay1crud_bloc.dart';

abstract class Pay1CrudEvents extends Equatable {
	const Pay1CrudEvents();

	@override
	List<Object> get props => [];
}

class Pay1CrudTambahEvent extends Pay1CrudEvents {
	final Pay1CrudModel record;
	const Pay1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Pay1CrudUbahEvent extends Pay1CrudEvents {
	final Pay1CrudModel record;
	const Pay1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Pay1CrudHapusEvent extends Pay1CrudEvents {
	final String recordId;
	const Pay1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Pay1CrudLihatEvent extends Pay1CrudEvents {
	final String recordId;
	const Pay1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

