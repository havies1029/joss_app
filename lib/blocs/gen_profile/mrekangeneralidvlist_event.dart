part of 'mrekangeneralidvlist_bloc.dart';

abstract class MRekanGeneralIdvListEvents extends Equatable {
	const MRekanGeneralIdvListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents {}

class RefreshMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekanGeneralIdvListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents {
	final String recordId;

	const UbahMRekanGeneralIdvListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents{}
class HapusMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents{}
class CloseDialogMRekanGeneralIdvListEvent extends MRekanGeneralIdvListEvents{}
