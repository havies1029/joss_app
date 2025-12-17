part of 'regpar6cari_bloc.dart';

class Regpar6CariState extends Equatable {
  final String regpar1Id;
	final ListStatus status;
	final List<Regpar6CariModel> items;
	final bool hasReachedMax;
	const Regpar6CariState(
		{this.regpar1Id = '',
		this.status = ListStatus.initial,
		this.items = const <Regpar6CariModel>[],
		this.hasReachedMax = false,
		});

  const Regpar6CariState.reset() : this();

	const Regpar6CariState.success(List<Regpar6CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Regpar6CariState.failure() : this(status: ListStatus.failure);

	Regpar6CariState copyWith(
		{
      String? regpar1Id,
      List<Regpar6CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return Regpar6CariState(
      regpar1Id: regpar1Id ?? this.regpar1Id,
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [regpar1Id, status, items, hasReachedMax];
}
