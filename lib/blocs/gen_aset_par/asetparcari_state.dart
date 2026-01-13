part of 'asetparcari_bloc.dart';

class AsetParCariState extends Equatable {

	final ListStatus status;
	final List<AsetParCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String statusId;
	final Set<String> selectedIds;

	const AsetParCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetParCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = "",
		this.statusId = "",
		this.selectedIds = const <String>{}});

	const AsetParCariState.success(List<AsetParCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetParCariState.failure() : this(status: ListStatus.failure);

	AsetParCariState copyWith(
		{List<AsetParCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId,
		Set<String>? selectedIds
		}) {
		return AsetParCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			searchText: searchText ?? this.searchText,
			statusId: statusId ?? this.statusId,
			selectedIds: selectedIds ?? this.selectedIds,
		);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, statusId, selectedIds];
}
