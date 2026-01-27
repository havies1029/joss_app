part of 'mstsgroupinvcari_bloc.dart';

class MstsgroupinvCariState extends Equatable {

	final ListStatus status;
	final List<MstsgroupinvCariModel> items;
	final bool hasReachedMax;
	const MstsgroupinvCariState(
		{this.status = ListStatus.initial,
		this.items = const <MstsgroupinvCariModel>[],
		this.hasReachedMax = false,
		});

	const MstsgroupinvCariState.success(List<MstsgroupinvCariModel> items)
			: this(status: ListStatus.success, items: items);

	const MstsgroupinvCariState.failure() : this(status: ListStatus.failure);

	MstsgroupinvCariState copyWith(
		{List<MstsgroupinvCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return MstsgroupinvCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
