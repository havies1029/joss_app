part of 'statusasetcari_bloc.dart';

class StatusAsetCariState extends Equatable {

	final ListStatus status;
	final List<StatusAsetCariModel> items;
	final bool hasReachedMax;
  final String selectedStatusId;

	const StatusAsetCariState(
		{this.status = ListStatus.initial,
		this.items = const <StatusAsetCariModel>[],
		this.hasReachedMax = false,
    this.selectedStatusId = '',
		});

	const StatusAsetCariState.success(List<StatusAsetCariModel> items)
			: this(status: ListStatus.success, items: items);

	const StatusAsetCariState.failure() : this(status: ListStatus.failure);

	StatusAsetCariState copyWith(
		{List<StatusAsetCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId
		}){
		return StatusAsetCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedStatusId];
}
