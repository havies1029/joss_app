part of 'klaimrasiocobcari_bloc.dart';

abstract class KlaimrasiocobCariEvents extends Equatable {
	const KlaimrasiocobCariEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaimrasiocobCariEvent extends KlaimrasiocobCariEvents {}

class RefreshKlaimrasiocobCariEvent extends KlaimrasiocobCariEvents {
	final String searchText;

	const RefreshKlaimrasiocobCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

