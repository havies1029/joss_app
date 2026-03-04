part of 'promo1cari_bloc.dart';

class Promo1CariState extends Equatable {

	final ListStatus status;
	final List<Promo1CariModel> items;
	final bool hasReachedMax;
	final int hal;

	const Promo1CariState(
		{this.status = ListStatus.initial,
		this.items = const <Promo1CariModel>[],
		this.hasReachedMax = false,
		this.hal = 0});

	const Promo1CariState.success(List<Promo1CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Promo1CariState.failure() : this(status: ListStatus.failure);

	Promo1CariState copyWith(
		{List<Promo1CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal}){
		return Promo1CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal];
}
