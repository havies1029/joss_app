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

// ✅ Event baru khusus debug (tidak trigger rebuild tabel)
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
