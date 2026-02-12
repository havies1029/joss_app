part of 'messagescrud_bloc.dart';

abstract class MessagesCrudEvents extends Equatable {
	const MessagesCrudEvents();

	@override
	List<Object> get props => [];
}

class MessagesCrudTambahEvent extends MessagesCrudEvents {
	final MessagesCrudModel record;
	const MessagesCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MessagesCrudUbahEvent extends MessagesCrudEvents {
	final MessagesCrudModel record;
	const MessagesCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MessagesCrudHapusEvent extends MessagesCrudEvents {
	final String recordId;
	const MessagesCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MessagesCrudLihatEvent extends MessagesCrudEvents {
	final String recordId;
	const MessagesCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

