part of 'simulmvlist_bloc.dart';

abstract class SimulmvListEvents extends Equatable {
	const SimulmvListEvents();

	@override
	List<Object> get props => [];
}

class FetchSimulmvListEvent extends SimulmvListEvents {}

class RefreshSimulmvListEvent extends SimulmvListEvents {
	final int hal;
	final String searchText;

	const RefreshSimulmvListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahSimulmvListEvent extends SimulmvListEvents {
	final String recordId;

	const UbahSimulmvListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahSimulmvListEvent extends SimulmvListEvents{}
class HapusSimulmvListEvent extends SimulmvListEvents{}
class CloseDialogSimulmvListEvent extends SimulmvListEvents{}
