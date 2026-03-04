part of 'asetparcari_bloc.dart';

class AsetParCariState extends Equatable {
	final ListStatus status;
	final List<AsetParCariModel> items;
	final bool hasReachedMax;
	final int hal;
	final String searchText;
	final String statusId;
	final Set<String> selectedIds;
	final String selectedFilePolisParId;
	final String selectedFilePolisEqId;
	final String activeAsetParId;
	final String selectedId;
	final AsetParCariModel? selectedItem;
	final String? selectedProsesId;
	final String queryKey;
	final bool isFetching;

	const AsetParCariState({
		this.status = ListStatus.initial,
		this.items = const <AsetParCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = "",
		this.statusId = "",
		this.selectedIds = const <String>{},
		this.selectedFilePolisParId = "",
		this.selectedFilePolisEqId = "",
		this.activeAsetParId = "",
		this.selectedId = "",
		this.selectedItem,
		this.selectedProsesId,
		this.queryKey = '',
		this.isFetching = false,
	});

	const AsetParCariState.success(List<AsetParCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetParCariState.failure() : this(status: ListStatus.failure);

	static const _unset = Object();

	AsetParCariState copyWith({
		List<AsetParCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId,
		Set<String>? selectedIds,
		String? selectedFilePolisParId,
		String? selectedFilePolisEqId,
		String? activeAsetParId,
		String? selectedId,
		Object? selectedItem = _unset,
		String? selectedProsesId,
		String? queryKey,
		bool? isFetching,
	}) {
		return AsetParCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			searchText: searchText ?? this.searchText,
			statusId: statusId ?? this.statusId,
			selectedIds: selectedIds ?? this.selectedIds,
			selectedFilePolisParId: selectedFilePolisParId ?? this.selectedFilePolisParId,
			selectedFilePolisEqId: selectedFilePolisEqId ?? this.selectedFilePolisEqId,
			activeAsetParId: activeAsetParId ?? this.activeAsetParId,
			selectedId: selectedId ?? this.selectedId,
			selectedItem: identical(selectedItem, _unset)
					? this.selectedItem
					: selectedItem as AsetParCariModel?,
			selectedProsesId: selectedProsesId ?? this.selectedProsesId,
			queryKey: queryKey ?? this.queryKey,
			isFetching: isFetching ?? this.isFetching,
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
		selectedFilePolisParId,
		selectedFilePolisEqId,
		activeAsetParId,
		selectedId,
		selectedItem,
		selectedProsesId,
		queryKey,
		isFetching,
	];
}
