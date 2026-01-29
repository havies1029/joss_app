part of 'asethealthcari_bloc.dart';

abstract class AsetHealthCariEvents extends Equatable {
	const AsetHealthCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetHealthCariEvent extends AsetHealthCariEvents {}

class RefreshAsetHealthCariEvent extends AsetHealthCariEvents {
	final String searchText;
	final String statusId;

	const RefreshAsetHealthCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}

class DebugFetchAsetHealthCariEvent extends AsetHealthCariEvents {
	final String searchText;
	final String statusId;

	const DebugFetchAsetHealthCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}


class SelectHealthDetailEvent extends AsetHealthCariEvents {
	final String asethealthId;
	const SelectHealthDetailEvent(this.asethealthId);

	@override
	List<Object> get props => [asethealthId];
}

class UnselectHealthDetailEvent extends AsetHealthCariEvents {
	final String asethealthId;
	const UnselectHealthDetailEvent(this.asethealthId);

	@override
	List<Object> get props => [asethealthId];
}

class ClearHealthSelectionEvent extends AsetHealthCariEvents {
	const ClearHealthSelectionEvent();

	@override
	List<Object> get props => [];
}




class SelectPolisHealthDetailEvent extends AsetHealthCariEvents {
	final String filePolisId;
	const SelectPolisHealthDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class UnselectPolisHealthDetailEvent extends AsetHealthCariEvents {
	final String filePolisId;
	const UnselectPolisHealthDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class ClearPolisHealthSelectionEvent extends AsetHealthCariEvents {
	const ClearPolisHealthSelectionEvent();

	@override
	List<Object> get props => [];
}


class SelectSingleHealthDetailEvent extends AsetHealthCariEvents {
	final String asetHealthId;
	const SelectSingleHealthDetailEvent(this.asetHealthId);

	@override
	List<Object> get props => [asetHealthId];
}

class UnselectSingleHealthDetailEvent extends AsetHealthCariEvents {
	final String asetHealthId;
	const UnselectSingleHealthDetailEvent(this.asetHealthId);

	@override
	List<Object> get props => [asetHealthId];
}