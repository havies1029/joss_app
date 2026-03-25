part of 'hakaksescrud_bloc.dart';

abstract class HakaksesCrudEvents extends Equatable {
	const HakaksesCrudEvents();

	@override
	List<Object> get props => [];
}

class HakaksesCrudLihatEvent extends HakaksesCrudEvents {
	final String recordId;
	const HakaksesCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}


