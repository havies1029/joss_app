part of 'regmv1list_bloc.dart';

abstract class Regmv1ListEvents extends Equatable {
	const Regmv1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchRegmv1ListEvent extends Regmv1ListEvents {}

class RefreshRegmv1ListEvent extends Regmv1ListEvents {
	final int hal;
	final String searchText;

	const RefreshRegmv1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahRegmv1ListEvent extends Regmv1ListEvents {
	final String recordId;

	const UbahRegmv1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahRegmv1ListEvent extends Regmv1ListEvents{}
class HapusRegmv1ListEvent extends Regmv1ListEvents{}
class CloseDialogRegmv1ListEvent extends Regmv1ListEvents{}
