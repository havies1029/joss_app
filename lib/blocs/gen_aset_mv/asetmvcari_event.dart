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

// ✅ Event baru khusus debug (tidak mengubah state UI)
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
