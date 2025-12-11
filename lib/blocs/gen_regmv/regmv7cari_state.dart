part of 'regmv7cari_bloc.dart';

class Regmv7CariState extends Equatable {
  final String regmv1Id;
	final ListStatus status;
	final List<Regmv7CariModel> items;
	final bool hasReachedMax;
	const Regmv7CariState(
		{
      this.regmv1Id = '',
      this.status = ListStatus.initial,
		this.items = const <Regmv7CariModel>[],
		this.hasReachedMax = false,
		});

  const Regmv7CariState.reset() : this();

	const Regmv7CariState.success(List<Regmv7CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regmv7CariState.failure() : this(status: ListStatus.failure);

	Regmv7CariState copyWith(
		{List<Regmv7CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? regmv1Id,
		}){
		return Regmv7CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			regmv1Id: regmv1Id ?? this.regmv1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regmv1Id];
}
