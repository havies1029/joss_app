part of 'asetmvcari_bloc.dart';

abstract class AsetMvCariEvents extends Equatable {
	const AsetMvCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetMvCariEvent extends AsetMvCariEvents {}

class RefreshAsetMvCariEvent extends AsetMvCariEvents {
	final String searchText;
	final String statusId;

	const RefreshAsetMvCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}

class DebugFetchAsetMvCariEvent extends AsetMvCariEvents {
	final String searchText;
	final String statusId;

	const DebugFetchAsetMvCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}


class SelectMvDetailEvent extends AsetMvCariEvents {
	final String asetMvId;
	const SelectMvDetailEvent(this.asetMvId);

	@override
	List<Object> get props => [asetMvId];
}

class UnselectMvDetailEvent extends AsetMvCariEvents {
	final String asetMvId;
	const UnselectMvDetailEvent(this.asetMvId);

	@override
	List<Object> get props => [asetMvId];
}

class ClearMvSelectionEvent extends AsetMvCariEvents {
	const ClearMvSelectionEvent();

	@override
	List<Object> get props => [];
}

class SelectPolisMvDetailEvent extends AsetMvCariEvents {
	final String filePolisId;
	const SelectPolisMvDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class UnselectPolisMvDetailEvent extends AsetMvCariEvents {
	final String filePolisId;
	const UnselectPolisMvDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class ClearPolisMvSelectionEvent extends AsetMvCariEvents {
	const ClearPolisMvSelectionEvent();

	@override
	List<Object> get props => [];
}


class SelectSingleMvDetailEvent extends AsetMvCariEvents {
	final String asetMvId;
	const SelectSingleMvDetailEvent(this.asetMvId);

	@override
	List<Object> get props => [asetMvId];
}

class UnselectSingleMvDetailEvent extends AsetMvCariEvents {
	final String asetMvId;
	const UnselectSingleMvDetailEvent(this.asetMvId);

	@override
	List<Object> get props => [asetMvId];
}

class SelectMvCariEvent extends AsetMvCariEvents {
	final AsetMvCariModel selectedItem;
	const SelectMvCariEvent({required this.selectedItem});
}