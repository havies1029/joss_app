part of 'endors1list_bloc.dart';

abstract class Endors1ListEvents extends Equatable {
	const Endors1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchEndors1ListEvent extends Endors1ListEvents {}

class RefreshEndors1ListEvent extends Endors1ListEvents {
	final int hal;
	final String searchText;

	const RefreshEndors1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahEndors1ListEvent extends Endors1ListEvents {
	final String recordId;

	const UbahEndors1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahEndors1ListEvent extends Endors1ListEvents{}
class HapusEndors1ListEvent extends Endors1ListEvents{}
class CloseDialogEndors1ListEvent extends Endors1ListEvents{}
