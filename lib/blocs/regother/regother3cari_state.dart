part of 'regother3cari_bloc.dart';

class Regother3cariState extends Equatable {

	final ListStatus status;
	final List<Regother3cariModel> items;
	final bool hasReachedMax;
  final String regother1Id;
	const Regother3cariState(
		{this.status = ListStatus.initial,
		this.items = const <Regother3cariModel>[],
		this.hasReachedMax = false,
    this.regother1Id = "",
		});

	const Regother3cariState.success(List<Regother3cariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regother3cariState.failure() : this(status: ListStatus.failure);

	Regother3cariState copyWith(
		{List<Regother3cariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? regother1Id,
		}){
		return Regother3cariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      regother1Id: regother1Id ?? this.regother1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regother1Id];
}
