part of 'reqcompro_bloc.dart';

abstract class ReqComproEvents extends Equatable {
	const ReqComproEvents();

	@override
	List<Object> get props => [];
}

class ReqComproTambahEvent extends ReqComproEvents {
	final ReqComproModel record;
	const ReqComproTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class ReqComproUbahEvent extends ReqComproEvents {
	final ReqComproModel record;
	const ReqComproUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class ReqComproHapusEvent extends ReqComproEvents {
	final String recordId;
	const ReqComproHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ReqComproLihatEvent extends ReqComproEvents {
	final String recordId;
	const ReqComproLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

