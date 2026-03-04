part of 'regmv7cari_bloc.dart';

abstract class Regmv7CariEvents extends Equatable {
	const Regmv7CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegmv7CariEvent extends Regmv7CariEvents {}

class RefreshRegmv7CariEvent extends Regmv7CariEvents {
  final String regmv1Id;
  const RefreshRegmv7CariEvent({required this.regmv1Id});

  @override
  List<Object> get props => [regmv1Id];
}

class Regmv7CariResetEvent extends Regmv7CariEvents {}
