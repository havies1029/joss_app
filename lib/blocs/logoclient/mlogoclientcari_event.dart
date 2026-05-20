part of 'mlogoclientcari_bloc.dart';

abstract class MlogoclientCariEvents extends Equatable {
	const MlogoclientCariEvents();

	@override
	List<Object> get props => [];
}

class FetchMlogoclientCariEvent extends MlogoclientCariEvents {}

class RefreshMlogoclientCariEvent extends MlogoclientCariEvents {}

