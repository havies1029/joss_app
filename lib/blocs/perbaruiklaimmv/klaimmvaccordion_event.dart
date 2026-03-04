part of 'klaimmvaccordion_bloc.dart';

abstract class KlaimmvaccordionEvents extends Equatable {
	const KlaimmvaccordionEvents();

	@override
	List<Object> get props => [];
}

class KlaimmvaccordionToggleEvent extends KlaimmvaccordionEvents {
  final int index;
  const KlaimmvaccordionToggleEvent({required this.index});

  @override
  List<Object> get props => [index];
}