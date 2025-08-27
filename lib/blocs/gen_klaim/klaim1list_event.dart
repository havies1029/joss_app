part of 'klaim1list_bloc.dart';

abstract class Klaim1ListEvents extends Equatable {
	const Klaim1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaim1ListEvent extends Klaim1ListEvents {}

class RefreshKlaim1ListEvent extends Klaim1ListEvents {
	final int hal;
	final String searchText;

	const RefreshKlaim1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahKlaim1ListEvent extends Klaim1ListEvents {
	final String recordId;

	const UbahKlaim1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahKlaim1ListEvent extends Klaim1ListEvents{}
class HapusKlaim1ListEvent extends Klaim1ListEvents{}
class CloseDialogKlaim1ListEvent extends Klaim1ListEvents{}
