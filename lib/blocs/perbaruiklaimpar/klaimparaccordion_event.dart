part of 'klaimparaccordion_bloc.dart';

abstract class KlaimparaccordionEvents extends Equatable {
	const KlaimparaccordionEvents();

	@override
	List<Object> get props => [];
}

class KlaimparaccordionToggleEvent extends KlaimparaccordionEvents {
  final int index;
  const KlaimparaccordionToggleEvent({required this.index});

  @override
  List<Object> get props => [index];
}