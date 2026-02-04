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
	final String? selectedProsesId;

	const AsetMvCariState({
		this.status = ListStatus.initial,
		this.items = const <AsetMvCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = '',
		this.statusId = '',
		this.selectedIds = const <String>{},
		this.selectedFilePolisId = "",
		this.activeAsetMvId = "",
		this.selectedId = "",
		this.selectedItem,
		this.selectedProsesId,
	});

	const AsetMvCariState.success(List<AsetMvCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetMvCariState.failure() : this(status: ListStatus.failure);

	static const _unset = Object();

	AsetMvCariState copyWith({
		List<AsetMvCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId,
		Set<String>? selectedIds,
		String? selectedFilePolisId,
		String? activeAsetMvId,
		String? selectedId,

		// penting: pakai Object? + default _unset
		Object? selectedItem = _unset,

		String? selectedProsesId,
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

			// ini yang bikin null beneran ke-set
			selectedItem: identical(selectedItem, _unset)
					? this.selectedItem
					: selectedItem as AsetMvCariModel?,

			selectedProsesId: selectedProsesId ?? this.selectedProsesId,
		);
	}

	@override
	List<Object?> get props => [
		status,
		items,
		hasReachedMax,
		hal,
		searchText,
		statusId,
		selectedIds,
		selectedFilePolisId,
		activeAsetMvId,
		selectedId,
		selectedItem,
		selectedProsesId,
	];
}
