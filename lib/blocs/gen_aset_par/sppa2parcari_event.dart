part of 'sppa2parcari_bloc.dart';

abstract class Sppa2parCariEvents extends Equatable {
	const Sppa2parCariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2parCariEvent extends Sppa2parCariEvents {}

class RefreshSppa2parCariEvent extends Sppa2parCariEvents {
  final String sppa1Id;
	final String searchText;

	const RefreshSppa2parCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

