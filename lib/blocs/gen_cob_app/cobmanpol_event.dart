part of 'cobmanpol_bloc.dart';

abstract class CobManPolEvents extends Equatable {
	const CobManPolEvents();

	@override
	List<Object> get props => [];
}

class FetchCobManPolEvent extends CobManPolEvents {}

class RefreshCobManPolEvent extends CobManPolEvents {}

class SelectCobButton extends CobManPolEvents {
  final String id;

  const SelectCobButton(this.id);

  @override
  List<Object> get props => [id];
}
