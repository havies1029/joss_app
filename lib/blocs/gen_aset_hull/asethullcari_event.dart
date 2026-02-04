part of 'asethullcari_bloc.dart';

abstract class AsethullCariEvents extends Equatable {
	const AsethullCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsethullCariEvent extends AsethullCariEvents {}

class RefreshAsethullCariEvent extends AsethullCariEvents {
  final String searchText;
  final String statusId;

  const RefreshAsethullCariEvent({required this.searchText, required this.statusId});
  
	@override
	List<Object> get props => [searchText, statusId];
}

class DebugFetchAsethullCariEvent extends AsethullCariEvents {
	final String searchText;
	final String statusId;

	const DebugFetchAsethullCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}


class SelectHullDetailEvent extends AsethullCariEvents {
	final String asetHullId;
	const SelectHullDetailEvent(this.asetHullId);

	@override
	List<Object> get props => [asetHullId];
}

class UnselectHullDetailEvent extends AsethullCariEvents {
	final String asetHullId;
	const UnselectHullDetailEvent(this.asetHullId);

	@override
	List<Object> get props => [asetHullId];
}

class ClearHullSelectionEvent extends AsethullCariEvents {
	const ClearHullSelectionEvent();

	@override
	List<Object> get props => [];
}



class SelectPolisHullDetailEvent extends AsethullCariEvents {
	final String filePolisId;
	const SelectPolisHullDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class UnselectPolisHullDetailEvent extends AsethullCariEvents {
	final String filePolisId;
	const UnselectPolisHullDetailEvent(this.filePolisId);

	@override
	List<Object> get props => [filePolisId];
}

class ClearPolisHullSelectionEvent extends AsethullCariEvents {
	const ClearPolisHullSelectionEvent();

	@override
	List<Object> get props => [];
}


class SelectSingleHullDetailEvent extends AsethullCariEvents {
	final String asetHullId;
	const SelectSingleHullDetailEvent(this.asetHullId);

	@override
	List<Object> get props => [asetHullId];
}

class UnselectSingleHullDetailEvent extends AsethullCariEvents {
	final String asetHullId;
	const UnselectSingleHullDetailEvent(this.asetHullId);

	@override
	List<Object> get props => [asetHullId];
}

class SelectHullCariEvent extends AsethullCariEvents {
	final AsethullCariModel selectedItem;
	const SelectHullCariEvent({required this.selectedItem});
}

class SelectProsesHullIdEvent extends AsethullCariEvents {
	final String? prosesId;
	const SelectProsesHullIdEvent(this.prosesId);
}