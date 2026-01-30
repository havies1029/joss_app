part of 'regrenewal2cari_bloc.dart';

abstract class Regrenewal2CariEvents extends Equatable {
	const Regrenewal2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegrenewal2CariEvent extends Regrenewal2CariEvents {}

class RefreshRegrenewal2CariEvent extends Regrenewal2CariEvents {
  final String regrenew1Id;
  const RefreshRegrenewal2CariEvent({required this.regrenew1Id});

  @override
  List<Object> get props => [regrenew1Id];
}

