part of 'asetmvcari_bloc.dart';

class AsetMvCariState extends Equatable {

	final ListStatus status;
	final List<AsetMvCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String statusId;
	final Set<String> selectedIds;
	final String selectedFilePolisId;
	final String activeAsetMvId;
	final String selectedId;
	final AsetMvCariModel? selectedItem;

	const AsetMvCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetMvCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = '',
		this.statusId = '',
		this.selectedIds = const <String>{},
		this.selectedFilePolisId = "",
		this.activeAsetMvId = "",
		this.selectedId = "",
		this.selectedItem
	});

	const AsetMvCariState.success(List<AsetMvCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetMvCariState.failure() : this(status: ListStatus.failure);

	AsetMvCariState copyWith(
		{List<AsetMvCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId,
		Set<String>? selectedIds,
		String? selectedFilePolisId,
		String? activeAsetMvId,
		String? selectedId,
		AsetMvCariModel? selectedItem,
	}) {
		return AsetMvCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			searchText: searchText ?? this.searchText,
			statusId: statusId ?? this.statusId,
			selectedIds: selectedIds ?? this.selectedIds,
			selectedFilePolisId: selectedFilePolisId ?? this.selectedFilePolisId,
			activeAsetMvId: activeAsetMvId ?? this.activeAsetMvId,
			selectedId: selectedId ?? this.selectedId,
			selectedItem: selectedItem ?? this.selectedItem,
		);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, statusId, selectedIds, selectedFilePolisId, activeAsetMvId, selectedId, selectedItem ?? ""];
}
