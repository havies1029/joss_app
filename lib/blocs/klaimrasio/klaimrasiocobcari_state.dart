part of 'klaimrasiocobcari_bloc.dart';

class KlaimrasiocobCariState extends Equatable {

	final ListStatus status;
	final KlaimrasiocariModel klaimRasio;
	final bool hasReachedMax;
  final String searchText;
  final List<String> selectedIds;

	KlaimrasiocobCariState(
		{this.status = ListStatus.initial,
		KlaimrasiocariModel? klaimRasio,
		this.hasReachedMax = false,
    this.searchText = "",
    this.selectedIds = const []}) : klaimRasio = klaimRasio ?? KlaimrasiocariModel(cobs: [], grandcurrs: []);

	KlaimrasiocobCariState copyWith(
		{KlaimrasiocariModel? klaimRasio,
		bool? hasReachedMax,
		ListStatus? status,
    String? searchText,
    List<String>? selectedIds}) {
		return KlaimrasiocobCariState(
			klaimRasio: klaimRasio ?? this.klaimRasio,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      searchText: searchText ?? this.searchText,
      selectedIds: selectedIds ?? this.selectedIds);
	}

	@override
	List<Object> get props => [status, klaimRasio, hasReachedMax, searchText, selectedIds];
}
