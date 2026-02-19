part of 'klaimmvaccordion_bloc.dart';

class KlaimmvaccordionState extends Equatable {
  final int? openedIndex;
  final int? previousIndex;
  const KlaimmvaccordionState(this.openedIndex, this.previousIndex);

  KlaimmvaccordionState copyWith({
    int? openedIndex,
    int? previousIndex,
  }) {
    return KlaimmvaccordionState(
      openedIndex ?? this.openedIndex,
      previousIndex ?? this.previousIndex,
    );
  } 

  @override
  List<Object?> get props => [openedIndex, previousIndex];
}