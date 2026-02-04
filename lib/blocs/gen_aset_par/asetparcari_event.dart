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



class SelectPolisParDetailEvent extends AsetParCariEvents {
	final String filePolisParId;
	const SelectPolisParDetailEvent(this.filePolisParId);

	@override
	List<Object> get props => [filePolisParId];
}

class UnselectPolisParDetailEvent extends AsetParCariEvents {
	final String filePolisParId;
	const UnselectPolisParDetailEvent(this.filePolisParId);

	@override
	List<Object> get props => [filePolisParId];
}

class ClearPolisParSelectionEvent extends AsetParCariEvents {
	const ClearPolisParSelectionEvent();

	@override
	List<Object> get props => [];
}






class SelectPolisEqDetailEvent extends AsetParCariEvents {
	final String filePolisEqId;
	const SelectPolisEqDetailEvent(this.filePolisEqId);

	@override
	List<Object> get props => [filePolisEqId];
}

class UnselectPolisEqDetailEvent extends AsetParCariEvents {
	final String filePolisEqId;
	const UnselectPolisEqDetailEvent(this.filePolisEqId);

	@override
	List<Object> get props => [filePolisEqId];
}

class ClearPolisEqSelectionEvent extends AsetParCariEvents {
	const ClearPolisEqSelectionEvent();

	@override
	List<Object> get props => [];
}

class SelectSingleParDetailEvent extends AsetParCariEvents {
	final String asetParId;
	const SelectSingleParDetailEvent(this.asetParId);

	@override
	List<Object> get props => [asetParId];
}

class UnselectSingleParDetailEvent extends AsetParCariEvents {
	final String asetParId;
	const UnselectSingleParDetailEvent(this.asetParId);

	@override
	List<Object> get props => [asetParId];
}

class SelectParCariEvent extends AsetParCariEvents {
	final AsetParCariModel selectedItem;
	const SelectParCariEvent({required this.selectedItem});
}

class UnselectParCariEvent extends AsetParCariEvents {
	final AsetParCariModel selectedItem;
	const UnselectParCariEvent({required this.selectedItem});
}