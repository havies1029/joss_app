part of 'regrenewcari_bloc.dart';

abstract class RegrenewCariEvents extends Equatable {
	const RegrenewCariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegrenewCariEvent extends RegrenewCariEvents {}

class RefreshRegrenewCariEvent extends RegrenewCariEvents {
	final String searchText;

	const RefreshRegrenewCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

