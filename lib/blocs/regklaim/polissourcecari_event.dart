part of 'polissourcecari_bloc.dart';

abstract class PolissourcecariEvents extends Equatable {
	const PolissourcecariEvents();

	@override
	List<Object> get props => [];
}

class FetchPolissourcecariEvent extends PolissourcecariEvents {}

class RefreshPolissourcecariEvent extends PolissourcecariEvents {}

class SelectPolissourcecariEvent extends PolissourcecariEvents {
  final String polissourceId;

  const SelectPolissourcecariEvent({required this.polissourceId});

  @override
  List<Object> get props => [polissourceId];
}