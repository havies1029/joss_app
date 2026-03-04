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

class TrackKlaim1ListEvent extends Klaim1ListEvents {
	final String klaim1Id;

	const TrackKlaim1ListEvent({required this.klaim1Id});

	@override
	List<Object> get props => [klaim1Id];
}

class TambahKlaim1ListEvent extends Klaim1ListEvents{}
class HapusKlaim1ListEvent extends Klaim1ListEvents{}
class CloseDialogKlaim1ListEvent extends Klaim1ListEvents{}
