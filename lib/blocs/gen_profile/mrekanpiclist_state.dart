part of 'mrekanpiclist_bloc.dart';

class MRekanPicListState extends Equatable {
	final ListStatus status;
	final List<MRekanPicListModel> items;
	final bool hasReachedMax;
	final bool isFetchingMore;
	final int hal;
	final String viewMode;
	final String searchText;
	final String recordId;

	const MRekanPicListState({
		this.status = ListStatus.initial,
		this.items = const <MRekanPicListModel>[],
		this.hasReachedMax = false,
		this.isFetchingMore = false,
		this.hal = 0,
		this.viewMode = "",
		this.searchText = "",
		this.recordId = "",
	});

	MRekanPicListState copyWith({
		List<MRekanPicListModel>? items,
		bool? hasReachedMax,
		bool? isFetchingMore,
		ListStatus? status,
		int? hal,
		String? viewMode,
		String? searchText,
		String? recordId,
	}) {
		return MRekanPicListState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			isFetchingMore: isFetchingMore ?? this.isFetchingMore,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			viewMode: viewMode ?? this.viewMode,
			searchText: searchText ?? this.searchText,
			recordId: recordId ?? this.recordId,
		);
	}

	@override
	List<Object> get props => [
		status,
		items,
		hasReachedMax,
		isFetchingMore,
		hal,
		viewMode,
		recordId,
		searchText,
	];
}