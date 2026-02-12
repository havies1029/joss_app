part of 'roomcari_bloc.dart';

abstract class RoomCariEvents extends Equatable {
	const RoomCariEvents();

	@override
	List<Object> get props => [];
}

class FetchRoomCariEvent extends RoomCariEvents {
	final int hal;
	final String searchText;

	const FetchRoomCariEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class RefreshRoomCariEvent extends RoomCariEvents {
	final int hal;
	final String searchText;

	const RefreshRoomCariEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

