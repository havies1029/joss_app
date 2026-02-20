
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calmvaccordion_event.dart';
part 'calmvaccordion_state.dart';

class CalmvAccordionBloc extends Bloc<CalmvAccordionEvents, CalmvAccordionState> {
  CalmvAccordionBloc() : super(const CalmvAccordionState(0, null)) {
    on<CalmvaccordionToggleEvent>(onToggle);
  }

  Future<void> onToggle(CalmvaccordionToggleEvent event, Emitter<CalmvAccordionState> emit) async {
    int? newOpenedIndex = state.openedIndex == event.index ? null : event.index;
    emit(state.copyWith(openedIndex: newOpenedIndex, previousIndex: state.openedIndex));
  }
}