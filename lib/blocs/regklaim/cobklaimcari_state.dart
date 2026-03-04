part of 'cobklaimcari_bloc.dart';

class CobklaimcariState extends Equatable {

	final ListStatus status;
	final List<CobklaimcariModel> items;
	final bool hasReachedMax;
  final CobklaimcariModel? selectedItem;
	const CobklaimcariState(
		{this.status = ListStatus.initial,
		this.items = const <CobklaimcariModel>[],
		this.hasReachedMax = false,
    this.selectedItem,
		});

	const CobklaimcariState.success(List<CobklaimcariModel> items)
			: this(status: ListStatus.success, items: items);

	const CobklaimcariState.failure() : this(status: ListStatus.failure);

	CobklaimcariState copyWith(
		{List<CobklaimcariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
	  CobklaimcariModel? selectedItem,
	}) => CobklaimcariState(
		items: items ?? this.items,
		hasReachedMax: hasReachedMax ?? this.hasReachedMax,
		status: status ?? this.status,
	  selectedItem: selectedItem ?? this.selectedItem
	);

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedItem ?? ''];
}
