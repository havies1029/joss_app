part of 'mrekangeneralcmplist_bloc.dart';

abstract class MRekanGeneralCmpListEvents extends Equatable {
	const MRekanGeneralCmpListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents {}

class RefreshMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekanGeneralCmpListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents {
	final String recordId;

	const UbahMRekanGeneralCmpListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents{}
class HapusMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents{}
class CloseDialogMRekanGeneralCmpListEvent extends MRekanGeneralCmpListEvents{}
