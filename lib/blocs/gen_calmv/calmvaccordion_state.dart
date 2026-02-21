part of 'calmvaccordion_bloc.dart';

class CalmvAccordionState extends Equatable {
  final int? openedIndex;
  final int? previousIndex;
  const CalmvAccordionState(this.openedIndex, this.previousIndex);

  CalmvAccordionState copyWith({
    int? openedIndex,
    int? previousIndex,
  }) {
    return CalmvAccordionState(
      openedIndex ?? this.openedIndex,
      previousIndex ?? this.previousIndex,
    );
  }

  @override
  List<Object?> get props => [openedIndex, previousIndex];
}