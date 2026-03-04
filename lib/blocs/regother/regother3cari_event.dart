part of 'regother3cari_bloc.dart';

abstract class Regother3cariEvents extends Equatable {
	const Regother3cariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegother3cariEvent extends Regother3cariEvents {}

class RefreshRegother3cariEvent extends Regother3cariEvents {
  final String regother1Id;
  const RefreshRegother3cariEvent({this.regother1Id = ""});

  @override
  List<Object> get props => [regother1Id];
}

