part of 'regother1list_bloc.dart';

abstract class Regother1ListEvents extends Equatable {
	const Regother1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchRegother1ListEvent extends Regother1ListEvents {}

class RefreshRegother1ListEvent extends Regother1ListEvents {
	final int hal;
	final String searchText;

	const RefreshRegother1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahRegother1ListEvent extends Regother1ListEvents {
	final String recordId;

	const UbahRegother1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahRegother1ListEvent extends Regother1ListEvents{}
class HapusRegother1ListEvent extends Regother1ListEvents{}
class CloseDialogRegother1ListEvent extends Regother1ListEvents{}
