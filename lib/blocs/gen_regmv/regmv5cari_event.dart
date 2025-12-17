part of 'regmv5cari_bloc.dart';

abstract class Regmv5CariEvents extends Equatable {
	const Regmv5CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegmv5CariEvent extends Regmv5CariEvents {}

class RefreshRegmv5CariEvent extends Regmv5CariEvents {
  final String regmv1Id;

  const RefreshRegmv5CariEvent({required this.regmv1Id});

  @override
  List<Object> get props => [regmv1Id];
}

