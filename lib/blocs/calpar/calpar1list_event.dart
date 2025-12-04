part of 'calpar1list_bloc.dart';

abstract class Calpar1ListEvents extends Equatable {
	const Calpar1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchCalpar1ListEvent extends Calpar1ListEvents {}

class RefreshCalpar1ListEvent extends Calpar1ListEvents {
	final int hal;
	final String searchText;

	const RefreshCalpar1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahCalpar1ListEvent extends Calpar1ListEvents {
	final String recordId;

	const UbahCalpar1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahCalpar1ListEvent extends Calpar1ListEvents{}
class HapusCalpar1ListEvent extends Calpar1ListEvents{}
class CloseDialogCalpar1ListEvent extends Calpar1ListEvents{}

class CalPar2RegParEvent extends Calpar1ListEvents {
	final String calpar1Id;

	const CalPar2RegParEvent({required this.calpar1Id});

	@override
	List<Object> get props => [calpar1Id];
}