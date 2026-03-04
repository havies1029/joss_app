part of 'calmv1list_bloc.dart';

abstract class Calmv1ListEvents extends Equatable {
	const Calmv1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchCalmv1ListEvent extends Calmv1ListEvents {}

class RefreshCalmv1ListEvent extends Calmv1ListEvents {
	final int hal;
	final String searchText;

	const RefreshCalmv1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahCalmv1ListEvent extends Calmv1ListEvents {
	final String recordId;

	const UbahCalmv1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahCalmv1ListEvent extends Calmv1ListEvents{}
class HapusCalmv1ListEvent extends Calmv1ListEvents{}
class CloseDialogCalmv1ListEvent extends Calmv1ListEvents{}

class CalMv2RegMvEvent extends Calmv1ListEvents {
	final String calmv1Id;

	const CalMv2RegMvEvent({required this.calmv1Id});

	@override
	List<Object> get props => [calmv1Id];
}

class ClearProcessMessageEvent extends Calmv1ListEvents {}

