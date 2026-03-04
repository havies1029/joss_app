part of 'historybayar2cari_bloc.dart';

class Historybayar2CariState extends Equatable {

	final ListStatus status;
	final List<Historybayar2CariModel> items;
	final bool hasReachedMax;
  final String inv1Id;
	const Historybayar2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Historybayar2CariModel>[],
		this.hasReachedMax = false,
    this.inv1Id = '',
		});

	const Historybayar2CariState.success(List<Historybayar2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Historybayar2CariState.failure() : this(status: ListStatus.failure);

	Historybayar2CariState copyWith(
		{List<Historybayar2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? inv1Id,
		}){
		return Historybayar2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      inv1Id: inv1Id ?? this.inv1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, inv1Id];
}
