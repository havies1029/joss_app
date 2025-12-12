part of 'regmv4cari_bloc.dart';

abstract class Regmv4CariEvents extends Equatable {
	const Regmv4CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegmv4CariEvent extends Regmv4CariEvents {}

class RefreshRegmv4CariEvent extends Regmv4CariEvents {
  final String regmv1Id;
  const RefreshRegmv4CariEvent({required this.regmv1Id}); 

  @override
  List<Object> get props => [regmv1Id];
}

