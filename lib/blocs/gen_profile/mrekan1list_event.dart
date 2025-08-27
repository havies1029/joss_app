part of 'mrekan1list_bloc.dart';

abstract class MRekan1ListEvents extends Equatable {
	const MRekan1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekan1ListEvent extends MRekan1ListEvents {}

class RefreshMRekan1ListEvent extends MRekan1ListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekan1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekan1ListEvent extends MRekan1ListEvents {
	final String recordId;

	const UbahMRekan1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekan1ListEvent extends MRekan1ListEvents{}
class HapusMRekan1ListEvent extends MRekan1ListEvents{}
class CloseDialogMRekan1ListEvent extends MRekan1ListEvents{}
