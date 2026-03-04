part of 'berita2cari_bloc.dart';

class Berita2CariState extends Equatable {

	final ListStatus status;
	final List<Berita2CariModel> items;
	final bool hasReachedMax;
  final String berita1Id;
	const Berita2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Berita2CariModel>[],
		this.hasReachedMax = false,
    this.berita1Id = '',
		});

	const Berita2CariState.success(List<Berita2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Berita2CariState.failure() : this(status: ListStatus.failure);

	Berita2CariState copyWith(
		{List<Berita2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? berita1Id,
		}){
		return Berita2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			berita1Id: berita1Id ?? this.berita1Id,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, berita1Id];
}
