part of 'dn1cari_bloc.dart';

class Dn1CariState extends Equatable {

	final ListStatus status;
	final List<Dn1CariModel> items;
	final bool hasReachedMax;
  final String sppa1Id;
	const Dn1CariState(
		{this.status = ListStatus.initial,
		this.items = const <Dn1CariModel>[],
		this.hasReachedMax = false,
    this.sppa1Id = ''
		});

	const Dn1CariState.success(List<Dn1CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Dn1CariState.failure() : this(status: ListStatus.failure);

	Dn1CariState copyWith(
		{List<Dn1CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? sppa1Id
		}){
		return Dn1CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      sppa1Id: sppa1Id ?? this.sppa1Id
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, sppa1Id];
}
