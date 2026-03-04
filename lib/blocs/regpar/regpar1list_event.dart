part of 'regpar1list_bloc.dart';

abstract class Regpar1ListEvents extends Equatable {
	const Regpar1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchRegpar1ListEvent extends Regpar1ListEvents {}

class RefreshRegpar1ListEvent extends Regpar1ListEvents {
	final int hal;
	final String searchText;

	const RefreshRegpar1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahRegpar1ListEvent extends Regpar1ListEvents {
	final String recordId;

	const UbahRegpar1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahRegpar1ListEvent extends Regpar1ListEvents{}
class HapusRegpar1ListEvent extends Regpar1ListEvents{}
class CloseDialogRegpar1ListEvent extends Regpar1ListEvents{}

