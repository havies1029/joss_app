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

	const AsetothersCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetothersCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.statusId = '',
    this.searchText = '',
    this.cobId = '',
		this.selectedIds = const <String>{}});

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
		Set<String>? selectedIds}) {
		return AsetothersCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      statusId: statusId ?? this.statusId,
      searchText: searchText ?? this.searchText,
      cobId: cobId ?? this.cobId,
			selectedIds: selectedIds ?? this.selectedIds,);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, statusId, searchText, cobId, selectedIds];
}
