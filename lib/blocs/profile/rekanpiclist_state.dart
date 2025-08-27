part of 'rekanpiclist_bloc.dart';

class RekanPicListState extends Equatable {

	final ListStatus status;
	final List<RekanPicListModel> items;
	final bool hasReachedMax;
	final int hal;
	final String viewMode;
	final String searchText;
	final String recordId;

	const RekanPicListState(
		{this.status = ListStatus.initial,
		this.items = const <RekanPicListModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.viewMode = "",
		this.searchText = "",
		this.recordId = ""});

	RekanPicListState copyWith(
		{List<RekanPicListModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? viewMode,
		String? searchText,
		String? recordId}) {
		return RekanPicListState(
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
