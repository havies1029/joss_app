part of 'mrekanpajaklist_bloc.dart';

abstract class MRekanPajakListEvents extends Equatable {
	const MRekanPajakListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanPajakListEvent extends MRekanPajakListEvents {}

class RefreshMRekanPajakListEvent extends MRekanPajakListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekanPajakListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekanPajakListEvent extends MRekanPajakListEvents {
	final String recordId;

	const UbahMRekanPajakListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanPajakListEvent extends MRekanPajakListEvents{}
class HapusMRekanPajakListEvent extends MRekanPajakListEvents{}
class CloseDialogMRekanPajakListEvent extends MRekanPajakListEvents{}
