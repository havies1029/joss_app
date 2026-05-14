part of 'sppa2otherscari_bloc.dart';

abstract class Sppa2othersCariEvents extends Equatable {
	const Sppa2othersCariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2othersCariEvent extends Sppa2othersCariEvents {}

class RefreshSppa2othersCariEvent extends Sppa2othersCariEvents {
  final String sppa1Id;
	final String searchText;

	const RefreshSppa2othersCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

