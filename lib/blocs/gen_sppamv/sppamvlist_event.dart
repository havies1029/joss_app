part of 'sppamvlist_bloc.dart';

abstract class SppamvListEvents extends Equatable {
	const SppamvListEvents();

	@override
	List<Object> get props => [];
}

class FetchSppamvListEvent extends SppamvListEvents {}

class RefreshSppamvListEvent extends SppamvListEvents {
	final int hal;
	final String searchText;

	const RefreshSppamvListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahSppamvListEvent extends SppamvListEvents {
	final String recordId;

	const UbahSppamvListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahSppamvListEvent extends SppamvListEvents{}
class HapusSppamvListEvent extends SppamvListEvents{}
class CloseDialogSppamvListEvent extends SppamvListEvents{}
