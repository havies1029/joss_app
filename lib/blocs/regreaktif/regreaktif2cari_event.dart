part of 'regreaktif2cari_bloc.dart';

abstract class Regreaktif2CariEvents extends Equatable {
	const Regreaktif2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchRegreaktif2CariEvent extends Regreaktif2CariEvents {}

class RefreshRegreaktif2CariEvent extends Regreaktif2CariEvents {
  final String regreaktif1Id;
  const RefreshRegreaktif2CariEvent({required this.regreaktif1Id});

  @override
  List<Object> get props => [regreaktif1Id];
}

