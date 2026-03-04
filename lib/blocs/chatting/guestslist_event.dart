part of 'guestslist_bloc.dart';

abstract class GuestsListEvents extends Equatable {
	const GuestsListEvents();

	@override
	List<Object> get props => [];
}

class FetchGuestsListEvent extends GuestsListEvents {}

class RefreshGuestsListEvent extends GuestsListEvents {
	final int hal;
	final String searchText;

	const RefreshGuestsListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahGuestsListEvent extends GuestsListEvents {
	final String recordId;

	const UbahGuestsListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahGuestsListEvent extends GuestsListEvents{}
class HapusGuestsListEvent extends GuestsListEvents{}
class CloseDialogGuestsListEvent extends GuestsListEvents{}
