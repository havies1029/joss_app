part of 'dnrekapcobcari_bloc.dart';

class DnrekapcobCariState extends Equatable {

	final ListStatus status;
	final List<DnrekapcobCariModel> items;
	final bool hasReachedMax;
  final Set<String> selectedIds;
	const DnrekapcobCariState(
		{this.status = ListStatus.initial,
		this.items = const <DnrekapcobCariModel>[],
		this.hasReachedMax = false,
    this.selectedIds = const <String>{},
		});

	const DnrekapcobCariState.success(List<DnrekapcobCariModel> items)
			: this(status: ListStatus.success, items: items);

	const DnrekapcobCariState.failure() : this(status: ListStatus.failure);

	DnrekapcobCariState copyWith(
		{List<DnrekapcobCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		Set<String>? selectedIds,
		}){
		return DnrekapcobCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedIds: selectedIds ?? this.selectedIds,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedIds];
}
