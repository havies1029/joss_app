part of 'klaim2list_bloc.dart';

abstract class Klaim2ListEvents extends Equatable {
	const Klaim2ListEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaim2ListEvent extends Klaim2ListEvents {}

class RefreshKlaim2ListEvent extends Klaim2ListEvents {
	final int hal;
	final String searchText;

	const RefreshKlaim2ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahKlaim2ListEvent extends Klaim2ListEvents {
	final String recordId;

	const UbahKlaim2ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahKlaim2ListEvent extends Klaim2ListEvents{}
class HapusKlaim2ListEvent extends Klaim2ListEvents{}
class CloseDialogKlaim2ListEvent extends Klaim2ListEvents{}
