part of 'endors2cari_bloc.dart';

class Endors2CariState extends Equatable {

	final ListStatus status;
	final List<Endors2CariModel> items;
	final bool hasReachedMax;
	const Endors2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Endors2CariModel>[],
		this.hasReachedMax = false,
		});

	const Endors2CariState.success(List<Endors2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Endors2CariState.failure() : this(status: ListStatus.failure);

	Endors2CariState copyWith(
		{List<Endors2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return Endors2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
