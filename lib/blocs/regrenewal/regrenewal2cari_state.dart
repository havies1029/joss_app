part of 'regrenewal2cari_bloc.dart';

class Regrenewal2CariState extends Equatable {

	final ListStatus status;
	final List<Regrenewal2CariModel> items;
	final bool hasReachedMax;
  final String regrenew1Id;

	const Regrenewal2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Regrenewal2CariModel>[],
		this.hasReachedMax = false,
    this.regrenew1Id = "",  
		});

	Regrenewal2CariState copyWith(
		{List<Regrenewal2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? regrenew1Id,
		}){
		return Regrenewal2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      regrenew1Id: regrenew1Id ?? this.regrenew1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, regrenew1Id];
}
