
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'klaimparaccordion_event.dart';
part 'klaimparaccordion_state.dart';

class KlaimparaccordionBloc extends Bloc<KlaimparaccordionEvents, KlaimparaccordionState> {
  KlaimparaccordionBloc() : super(const KlaimparaccordionState(0, null)) {
    on<KlaimparaccordionToggleEvent>(onToggle);
  }

  Future<void> onToggle(KlaimparaccordionToggleEvent event, Emitter<KlaimparaccordionState> emit) async {
    int? newOpenedIndex = state.openedIndex == event.index ? null : event.index;
    emit(state.copyWith(openedIndex: newOpenedIndex, previousIndex: state.openedIndex));
  }
}