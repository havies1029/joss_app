part of 'cobklaimcari_bloc.dart';

abstract class CobklaimcariEvents extends Equatable {
	const CobklaimcariEvents();

	@override
	List<Object> get props => [];
}

class FetchCobklaimcariEvent extends CobklaimcariEvents {}

class RefreshCobklaimcariEvent extends CobklaimcariEvents {}

class CobklaimcariItemSelectedEvent extends CobklaimcariEvents {
  final CobklaimcariModel selectedItem;
  const CobklaimcariItemSelectedEvent({required this.selectedItem});

  @override
  List<Object> get props => [selectedItem];
}

