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

  static const _sentinel = Object();

	MstatusringkasCariState copyWith(
		{Object? items = _sentinel,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId
		}){
		return MstatusringkasCariState(
			items: identical(items, _sentinel) ? this.items : items as List<MstatusringkasCariModel>,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId
			);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, selectedStatusId];
}
