part of 'regreaktifcari_bloc.dart';

abstract class RegreaktifCariEvents extends Equatable {
	const RegreaktifCariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegreaktifCariEvent extends RegreaktifCariEvents {}

class RefreshRegreaktifCariEvent extends RegreaktifCariEvents {
	final String searchText;

	const RefreshRegreaktifCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

