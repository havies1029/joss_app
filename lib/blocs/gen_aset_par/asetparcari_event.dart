part of 'asetparcari_bloc.dart';

abstract class AsetParCariEvents extends Equatable {
	const AsetParCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetParCariEvent extends AsetParCariEvents {}

class RefreshAsetParCariEvent extends AsetParCariEvents {
	final String searchText;
	final String statusId;

	const RefreshAsetParCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}

// ✅ Event baru khusus debug (tidak mempengaruhi UI)
class DebugFetchAsetParCariEvent extends AsetParCariEvents {
	final String searchText;
	final String statusId;

	const DebugFetchAsetParCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}


class SelectDetailEvent extends AsetParCariEvents {
	final String asetParId;
	const SelectDetailEvent(this.asetParId);

	@override
	List<Object> get props => [asetParId];
}

class UnselectDetailEvent extends AsetParCariEvents {
	final String asetParId;
	const UnselectDetailEvent(this.asetParId);

	@override
	List<Object> get props => [asetParId];
}

class ClearParSelectionEvent extends AsetParCariEvents {
	const ClearParSelectionEvent();

	@override
	List<Object> get props => [];
}