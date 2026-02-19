part of 'klaimmvstatuscari_bloc.dart';

class KlaimmvstatuscariState extends Equatable {

	final ListStatus status;
	final List<KlaimmvstatuscariModel> items;
	final bool hasReachedMax;
  final String klaim1Id;
	const KlaimmvstatuscariState(
		{this.status = ListStatus.initial,
		this.items = const <KlaimmvstatuscariModel>[],
		this.hasReachedMax = false,
    this.klaim1Id = '',
		});

	const KlaimmvstatuscariState.success(List<KlaimmvstatuscariModel> items)
			: this(status: ListStatus.success, items: items);

	const KlaimmvstatuscariState.failure() : this(status: ListStatus.failure);

	KlaimmvstatuscariState copyWith(
		{List<KlaimmvstatuscariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? klaim1Id,
		}){
		return KlaimmvstatuscariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      klaim1Id: klaim1Id ?? this.klaim1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, klaim1Id];
}
