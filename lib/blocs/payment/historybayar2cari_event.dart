part of 'historybayar2cari_bloc.dart';

abstract class Historybayar2CariEvents extends Equatable {
	const Historybayar2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchHistorybayar2CariEvent extends Historybayar2CariEvents {}

class RefreshHistorybayar2CariEvent extends Historybayar2CariEvents {
  final String inv1Id;
  const RefreshHistorybayar2CariEvent({required this.inv1Id});
  @override
  List<Object> get props => [inv1Id];
}

