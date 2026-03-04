part of 'regmv4cari_bloc.dart';

class Regmv4CariState extends Equatable {
  final String regmv1Id;
	final ListStatus status;
	final List<Regmv4CariModel> items;
	final bool hasReachedMax;
	const Regmv4CariState(
		{
      this.regmv1Id = '',
      this.status = ListStatus.initial,
      this.items = const <Regmv4CariModel>[],
      this.hasReachedMax = false,
		});

	Regmv4CariState copyWith(
		{List<Regmv4CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? regmv1Id,
		}){
		return Regmv4CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      regmv1Id: regmv1Id ?? this.regmv1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regmv1Id];
}
