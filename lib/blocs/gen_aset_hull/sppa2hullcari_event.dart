part of 'sppa2hullcari_bloc.dart';

abstract class Sppa2hullCariEvents extends Equatable {
	const Sppa2hullCariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2hullCariEvent extends Sppa2hullCariEvents {}

class RefreshSppa2hullCariEvent extends Sppa2hullCariEvents {
  final String sppa1Id;
	final String searchText;

	const RefreshSppa2hullCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

