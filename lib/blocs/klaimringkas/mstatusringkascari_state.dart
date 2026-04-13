part of 'mstatusringkascari_bloc.dart';

class MstatusringkasCariState extends Equatable {

	final ListStatus status;
	final List<MstatusringkasCariModel> items;
	final bool hasReachedMax;
  final String selectedStatusId;
	const MstatusringkasCariState(
		{this.status = ListStatus.initial,
		this.items = const <MstatusringkasCariModel>[],
		this.hasReachedMax = false,
    this.selectedStatusId = '10'
		});

	const MstatusringkasCariState.success(List<MstatusringkasCariModel> items)
			: this(status: ListStatus.success, items: items);

	const MstatusringkasCariState.failure() : this(status: ListStatus.failure);

	MstatusringkasCariState copyWith(
		{List<MstatusringkasCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId
		}){
		return MstatusringkasCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId
			);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, selectedStatusId];
}
