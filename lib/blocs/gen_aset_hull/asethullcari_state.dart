part of 'asethullcari_bloc.dart';

class AsethullCariState extends Equatable {

	final ListStatus status;
	final List<AsethullCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String statusId;
	final Set<String> selectedIds;
	final String selectedFilePolisId;
	final String activeAsetHullId;

	const AsethullCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsethullCariModel>[],
		this.hasReachedMax = false,
    this.hal = 1,
    this.searchText = "",
    this.statusId = "",
		this.selectedIds = const <String>{},
		this.selectedFilePolisId = "",
		this.activeAsetHullId = "",
		});

	const AsethullCariState.success(List<AsethullCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsethullCariState.failure() : this(status: ListStatus.failure);

	AsethullCariState copyWith(
		{List<AsethullCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    int? hal,
    String? searchText,
    String? statusId,
		Set<String>? selectedIds,
		String? selectedFilePolisId,
		String? activeAsetHullId,
		}){
		return AsethullCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText,
      statusId: statusId ?? this.statusId,
			selectedIds: selectedIds ?? this.selectedIds,
			selectedFilePolisId: selectedFilePolisId ?? this.selectedFilePolisId,
			activeAsetHullId: activeAsetHullId ?? this.activeAsetHullId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, statusId, selectedIds, selectedFilePolisId, activeAsetHullId];
}
