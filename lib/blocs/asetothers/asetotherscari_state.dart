part of 'asetotherscari_bloc.dart';

class AsetothersCariState extends Equatable {

	final ListStatus status;
	final List<AsetothersCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String statusId;
  final String searchText;
  final String cobId;
	final Set<String> selectedIds;
	final String selectedFilePolisId;
	final String activeAsetOthersId;
	final String selectedId;
	final AsetothersCariModel? selectedItem;
	final String? selectedProsesId;

	const AsetothersCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetothersCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.statusId = '',
    this.searchText = '',
    this.cobId = '',
		this.selectedIds = const <String>{},
		this.selectedFilePolisId = "",
		this.activeAsetOthersId = "",
		this.selectedId = "",
		this.selectedItem,
		this.selectedProsesId,
		});

	const AsetothersCariState.success(List<AsetothersCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetothersCariState.failure() : this(status: ListStatus.failure);

	AsetothersCariState copyWith(
		{List<AsetothersCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? statusId,
    String? searchText,
    String? cobId,
		Set<String>? selectedIds,
		String? selectedFilePolisId,
		String? activeAsetOthersId,
		String? selectedId,
		AsetothersCariModel? selectedItem,
		String? selectedProsesId,
		}) {
		return AsetothersCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      statusId: statusId ?? this.statusId,
      searchText: searchText ?? this.searchText,
      cobId: cobId ?? this.cobId,
			selectedIds: selectedIds ?? this.selectedIds,
			selectedFilePolisId: selectedFilePolisId ?? this.selectedFilePolisId,
			activeAsetOthersId: activeAsetOthersId ?? this.activeAsetOthersId,
			selectedId: selectedId ?? this.selectedId,
			selectedItem: selectedItem ?? this.selectedItem,
			selectedProsesId: selectedProsesId ?? this.selectedProsesId,
		);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, hal, statusId, searchText, cobId, selectedIds, selectedFilePolisId, activeAsetOthersId, selectedId, selectedItem, selectedProsesId];
}
