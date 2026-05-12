part of 'sppa2cari_bloc.dart';

abstract class Sppa2CariEvents extends Equatable {
	const Sppa2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2CariEvent extends Sppa2CariEvents {}

class RefreshSppa2CariEvent extends Sppa2CariEvents {
	final String searchText;

	const RefreshSppa2CariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

