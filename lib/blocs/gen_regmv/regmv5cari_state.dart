part of 'regmv5cari_bloc.dart';

class Regmv5CariState extends Equatable {
  final String regmv1Id;
	final ListStatus status;
	final List<Regmv5CariModel> items;
	final bool hasReachedMax;
	const Regmv5CariState(
		{this.regmv1Id = "",
		this.status = ListStatus.initial,
		this.items = const <Regmv5CariModel>[],
		this.hasReachedMax = false,
		});

	const Regmv5CariState.success(List<Regmv5CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regmv5CariState.failure() : this(status: ListStatus.failure);

	Regmv5CariState copyWith(
		{
      String? regmv1Id,
      List<Regmv5CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return Regmv5CariState(
      regmv1Id: regmv1Id ?? this.regmv1Id,
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [regmv1Id, status, items, hasReachedMax];
}
