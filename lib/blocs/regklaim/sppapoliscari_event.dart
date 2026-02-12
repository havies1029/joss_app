part of 'sppapoliscari_bloc.dart';

abstract class SppapoliscariEvents extends Equatable {
	const SppapoliscariEvents();

	@override
	List<Object> get props => [];
}

class FetchSppapoliscariEvent extends SppapoliscariEvents {}

class RefreshSppapoliscariEvent extends SppapoliscariEvents {
  final String cobKlaimId;  
  final String searchText;
  const RefreshSppapoliscariEvent({required this.cobKlaimId, required this.searchText});

  @override
  List<Object> get props => [cobKlaimId, searchText];

}

