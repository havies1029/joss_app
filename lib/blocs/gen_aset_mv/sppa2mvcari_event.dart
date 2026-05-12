part of 'sppa2mvcari_bloc.dart';

abstract class Sppa2mvCariEvents extends Equatable {
	const Sppa2mvCariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2mvCariEvent extends Sppa2mvCariEvents {}

class RefreshSppa2mvCariEvent extends Sppa2mvCariEvents {
  final String sppa1Id;
	final String searchText;

	const RefreshSppa2mvCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

