part of 'simulparlist_bloc.dart';

abstract class SimulparListEvents extends Equatable {
	const SimulparListEvents();

	@override
	List<Object> get props => [];
}

class FetchSimulparListEvent extends SimulparListEvents {}

class RefreshSimulparListEvent extends SimulparListEvents {
	final int hal;
	final String searchText;

	const RefreshSimulparListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahSimulparListEvent extends SimulparListEvents {
	final String recordId;

	const UbahSimulparListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahSimulparListEvent extends SimulparListEvents{}
class HapusSimulparListEvent extends SimulparListEvents{}
class CloseDialogSimulparListEvent extends SimulparListEvents{}
