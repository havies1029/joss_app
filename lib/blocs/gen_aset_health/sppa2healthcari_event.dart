part of 'sppa2healthcari_bloc.dart';

abstract class Sppa2healthCariEvents extends Equatable {
	const Sppa2healthCariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppa2healthCariEvent extends Sppa2healthCariEvents {}

class RefreshSppa2healthCariEvent extends Sppa2healthCariEvents {
  final String sppa1Id;
	final String searchText;

	const RefreshSppa2healthCariEvent({required this.sppa1Id, required this.searchText});

	@override
	List<Object> get props => [sppa1Id, searchText];
}

