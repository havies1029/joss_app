part of 'sppaparlist_bloc.dart';

abstract class SppaparListEvents extends Equatable {
	const SppaparListEvents();

	@override
	List<Object> get props => [];
}

class FetchSppaparListEvent extends SppaparListEvents {}

class RefreshSppaparListEvent extends SppaparListEvents {
	final int hal;
	final String searchText;

	const RefreshSppaparListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahSppaparListEvent extends SppaparListEvents {
	final String recordId;

	const UbahSppaparListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahSppaparListEvent extends SppaparListEvents{}
class HapusSppaparListEvent extends SppaparListEvents{}
class CloseDialogSppaparListEvent extends SppaparListEvents{}
