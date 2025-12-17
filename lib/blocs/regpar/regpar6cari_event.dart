part of 'regpar6cari_bloc.dart';

abstract class Regpar6CariEvents extends Equatable {
	const Regpar6CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegpar6CariEvent extends Regpar6CariEvents {}

class RefreshRegpar6CariEvent extends Regpar6CariEvents {
  final String regpar1Id;
  const RefreshRegpar6CariEvent({required this.regpar1Id});

  @override
  List<Object> get props => [regpar1Id];
}

class Regpar6CariResetEvent extends Regpar6CariEvents {}