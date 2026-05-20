part of 'mlogoclientcari_bloc.dart';

class MlogoclientCariState extends Equatable {

	final ListStatus status;
	final List<MlogoclientCariModel> items;
	final bool hasReachedMax;
	const MlogoclientCariState(
		{this.status = ListStatus.initial,
		this.items = const <MlogoclientCariModel>[],
		this.hasReachedMax = false,
		});

	const MlogoclientCariState.success(List<MlogoclientCariModel> items)
			: this(status: ListStatus.success, items: items);

	const MlogoclientCariState.failure() : this(status: ListStatus.failure);

	MlogoclientCariState copyWith(
		{List<MlogoclientCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return MlogoclientCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
