part of 'klaimparaccordion_bloc.dart';

class KlaimparaccordionState extends Equatable {
  final int? openedIndex;
  final int? previousIndex;
  const KlaimparaccordionState(this.openedIndex, this.previousIndex);

  KlaimparaccordionState copyWith({
    int? openedIndex,
    int? previousIndex,
  }) {
    return KlaimparaccordionState(
      openedIndex ?? this.openedIndex,
      previousIndex ?? this.previousIndex,
    );
  } 

  @override
  List<Object?> get props => [openedIndex, previousIndex];
}