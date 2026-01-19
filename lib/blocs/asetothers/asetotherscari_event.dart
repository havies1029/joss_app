part of 'asetotherscari_bloc.dart';

abstract class AsetothersCariEvents extends Equatable {
	const AsetothersCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetothersCariEvent extends AsetothersCariEvents {}

class RefreshAsetothersCariEvent extends AsetothersCariEvents {
	final String searchText;
  final String cobId;
  final String statusId;

	const RefreshAsetothersCariEvent({required this.searchText, required this.cobId, required this.statusId});

	@override
	List<Object> get props => [searchText, cobId, statusId];
}

class SelectOthersDetailEvent extends AsetothersCariEvents {
	final String asetOthersId;
	const SelectOthersDetailEvent(this.asetOthersId);

	@override
	List<Object> get props => [asetOthersId];
}

class UnselectOthersDetailEvent extends AsetothersCariEvents {
	final String asetOthersId;
	const UnselectOthersDetailEvent(this.asetOthersId);

	@override
	List<Object> get props => [];
}

class ClearOthersSelectionEvent extends AsetothersCariEvents {
	const ClearOthersSelectionEvent();

	@override
	List<Object> get props => [];
}