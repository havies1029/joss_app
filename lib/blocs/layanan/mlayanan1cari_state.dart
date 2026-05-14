part of 'mlayanan1cari_bloc.dart';

class Mlayanan1CariState extends Equatable {

	final ListStatus status;
	final List<Mlayanan1CariModel> items;
	final bool hasReachedMax;
  final String mlayanan1Id;

	const Mlayanan1CariState(
		{this.status = ListStatus.initial,
		this.items = const <Mlayanan1CariModel>[],
		this.hasReachedMax = false,
    this.mlayanan1Id = "",
		});

	const Mlayanan1CariState.success(List<Mlayanan1CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Mlayanan1CariState.failure() : this(status: ListStatus.failure);

	Mlayanan1CariState copyWith(
		{List<Mlayanan1CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? mlayanan1Id,
		}){
		return Mlayanan1CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      mlayanan1Id: mlayanan1Id ?? this.mlayanan1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, mlayanan1Id];
}
