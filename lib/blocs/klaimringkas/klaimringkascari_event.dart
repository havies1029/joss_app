part of 'klaimringkascari_bloc.dart';

abstract class KlaimringkasCariEvents extends Equatable {
	const KlaimringkasCariEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaimringkasCariEvent extends KlaimringkasCariEvents {}

class RefreshKlaimringkasCariEvent extends KlaimringkasCariEvents {
	final String selectedStatusId;

	const RefreshKlaimringkasCariEvent({required this.selectedStatusId});

	@override
	List<Object> get props => [selectedStatusId];
}

