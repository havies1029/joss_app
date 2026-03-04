part of 'promo1cari_bloc.dart';

abstract class Promo1CariEvents extends Equatable {
	const Promo1CariEvents();

	@override
	List<Object> get props => [];
}

class FetchPromo1CariEvent extends Promo1CariEvents {}

class RefreshPromo1CariEvent extends Promo1CariEvents {}

