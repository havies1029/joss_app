part of 'calpar1list_bloc.dart';

class Calpar1ListState extends Equatable {

	final ListStatus status;
	final List<Calpar1ListModel> items;
	final bool hasReachedMax;
	final int hal;
	final String viewMode;
	final String searchText;
	final String recordId;

	const Calpar1ListState(
		{this.status = ListStatus.initial,
		this.items = const <Calpar1ListModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.viewMode = "",
		this.searchText = "",
		this.recordId = ""});

	Calpar1ListState copyWith(
		{List<Calpar1ListModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? viewMode,
		String? searchText,
		String? recordId}) {
		return Calpar1ListState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			viewMode: viewMode ?? this.viewMode,
			searchText: searchText ?? this.searchText,
			recordId: recordId ?? this.recordId);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, viewMode, recordId, searchText];
}
