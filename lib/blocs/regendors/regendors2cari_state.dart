part of 'regendors2cari_bloc.dart';

class Regendors2CariState extends Equatable {

	final ListStatus status;
	final List<Regendors2CariModel> items;
	final bool hasReachedMax;
  final String regendors1Id;

	const Regendors2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Regendors2CariModel>[],
		this.hasReachedMax = false,
    this.regendors1Id = '',
		});

	const Regendors2CariState.success(List<Regendors2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regendors2CariState.failure() : this(status: ListStatus.failure);

	Regendors2CariState copyWith(
		{List<Regendors2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? regendors1Id
		}){
		return Regendors2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      regendors1Id: regendors1Id ?? this.regendors1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regendors1Id];
}
