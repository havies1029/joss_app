part of 'regendors2cari_bloc.dart';

abstract class Regendors2CariEvents extends Equatable {
	const Regendors2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegendors2CariEvent extends Regendors2CariEvents {}

class RefreshRegendors2CariEvent extends Regendors2CariEvents {
  final String regendors1Id;
  const RefreshRegendors2CariEvent({required this.regendors1Id});

  @override
  List<Object> get props => [regendors1Id];
}

