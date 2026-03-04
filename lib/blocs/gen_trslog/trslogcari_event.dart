part of 'trslogcari_bloc.dart';

abstract class TrslogCariEvents extends Equatable {
	const TrslogCariEvents();

	@override
	List<Object> get props => [];
}

class FetchTrslogCariEvent extends TrslogCariEvents {}

class RefreshTrslogCariEvent extends TrslogCariEvents {
	final String searchText;

	const RefreshTrslogCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

