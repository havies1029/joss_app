part of 'rekanpiccrud_bloc.dart';

abstract class RekanPicCrudEvents extends Equatable {
	const RekanPicCrudEvents();

	@override
	List<Object> get props => [];
}

class RekanPicCrudTambahEvent extends RekanPicCrudEvents {
	final RekanPicCrudModel record;
	const RekanPicCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanPicCrudUbahEvent extends RekanPicCrudEvents {
	final RekanPicCrudModel record;
	const RekanPicCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanPicCrudHapusEvent extends RekanPicCrudEvents {
	final String recordId;
	const RekanPicCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RekanPicCrudLihatEvent extends RekanPicCrudEvents {
	final String recordId;
	const RekanPicCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

