part of 'promo2cari_bloc.dart';

class Promo2CariState extends Equatable {

	final ListStatus status;
	final List<Promo2CariModel> items;
	final bool hasReachedMax;
  final String promo1Id;
	final int hal;

	const Promo2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Promo2CariModel>[],
		this.hasReachedMax = false,
    this.promo1Id = '',
		this.hal = 0});

	const Promo2CariState.success(List<Promo2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Promo2CariState.failure() : this(status: ListStatus.failure);

	Promo2CariState copyWith(
		{List<Promo2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? promo1Id,
		int? hal}){
		return Promo2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			promo1Id: promo1Id ?? this.promo1Id,
			hal: hal ?? this.hal);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, promo1Id, hal];
}
