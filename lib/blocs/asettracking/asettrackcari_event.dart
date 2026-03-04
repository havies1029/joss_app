part of 'asettrackcari_bloc.dart';

abstract class AsettrackCariEvents extends Equatable {
	const AsettrackCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsettrackCariEvent extends AsettrackCariEvents {}

class RefreshAsettrackCariEvent extends AsettrackCariEvents {
	final String searchText;

	const RefreshAsettrackCariEvent({required this.searchText});

	@override
	List<Object> get props => [searchText];
}

class SelectAsettrackCariEvent extends AsettrackCariEvents {
	final AsettrackCariModel selectedAsettrackCari;

	const SelectAsettrackCariEvent({required this.selectedAsettrackCari});

	@override
	List<Object> get props => [selectedAsettrackCari];
}
