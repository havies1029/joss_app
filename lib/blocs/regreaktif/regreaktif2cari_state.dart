part of 'regreaktif2cari_bloc.dart';

class Regreaktif2CariState extends Equatable {

	final ListStatus status;
	final List<Regreaktif2CariModel> items;
	final bool hasReachedMax;
  final String regreaktif1Id;
	const Regreaktif2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Regreaktif2CariModel>[],
		this.hasReachedMax = false,
    this.regreaktif1Id = "",
		});

	const Regreaktif2CariState.success(List<Regreaktif2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regreaktif2CariState.failure() : this(status: ListStatus.failure);

	Regreaktif2CariState copyWith(
		{List<Regreaktif2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? regreaktif1Id,
		}){
		return Regreaktif2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      regreaktif1Id: regreaktif1Id ?? this.regreaktif1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regreaktif1Id];
}
