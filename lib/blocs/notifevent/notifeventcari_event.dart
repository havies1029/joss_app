part of 'notifeventcari_bloc.dart';

abstract class NotifeventcariEvents extends Equatable {
	const NotifeventcariEvents();

	@override
	List<Object> get props => [];
}

class FetchNotifeventcariEvent extends NotifeventcariEvents {}

class RefreshNotifeventcariEvent extends NotifeventcariEvents {}

