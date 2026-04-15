part of 'sppaheader_bloc.dart';

abstract class SppaHeaderEvents extends Equatable {
	const SppaHeaderEvents();

	@override
	List<Object> get props => [];
}

class SppaHeaderLihatEvent extends SppaHeaderEvents {
	final String recordId;
	const SppaHeaderLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}


class SppaHeaderResetEvent extends SppaHeaderEvents {
	const SppaHeaderResetEvent();
}