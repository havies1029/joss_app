part of 'pay1list_bloc.dart';

class Pay1ListState extends Equatable {

	final ListStatus status;
	final List<Pay1ListModel> items;
	final bool hasReachedMax;
	final int hal;
	final String viewMode;
	final String searchText;
	final String recordId;

	const Pay1ListState(
		{this.status = ListStatus.initial,
		this.items = const <Pay1ListModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.viewMode = "",
		this.searchText = "",
		this.recordId = ""});

	Pay1ListState copyWith(
		{List<Pay1ListModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? viewMode,
		String? searchText,
		String? recordId}) {
		return Pay1ListState(
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
