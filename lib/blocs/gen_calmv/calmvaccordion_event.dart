

part of 'calmvaccordion_bloc.dart';

abstract class CalmvAccordionEvents extends Equatable {
  const CalmvAccordionEvents();

  @override
  List<Object> get props => [];
}

class CalmvaccordionToggleEvent extends CalmvAccordionEvents {
  final int index;
  const CalmvaccordionToggleEvent({required this.index});

  @override
  List<Object> get props => [index];
}