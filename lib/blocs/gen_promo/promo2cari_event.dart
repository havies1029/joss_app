part of 'promo2cari_bloc.dart';

abstract class Promo2CariEvents extends Equatable {
	const Promo2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchPromo2CariEvent extends Promo2CariEvents {}

class RefreshPromo2CariEvent extends Promo2CariEvents {
	final String promo1Id;

	const RefreshPromo2CariEvent({required this.promo1Id});

	@override
	List<Object> get props => [promo1Id];
}

