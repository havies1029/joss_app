part of 'asetparcari_bloc.dart';

abstract class AsetParCariEvents extends Equatable {
	const AsetParCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsetParCariEvent extends AsetParCariEvents {}

class RefreshAsetParCariEvent extends AsetParCariEvents {
	final String searchText;
  final String statusId;

	const RefreshAsetParCariEvent({required this.searchText, required this.statusId});

	@override
	List<Object> get props => [searchText, statusId];
}

