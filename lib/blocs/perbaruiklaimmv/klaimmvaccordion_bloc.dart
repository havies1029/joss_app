
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'klaimmvaccordion_event.dart';
part 'klaimmvaccordion_state.dart';

class KlaimmvaccordionBloc extends Bloc<KlaimmvaccordionEvents, KlaimmvaccordionState> {
  KlaimmvaccordionBloc() : super(const KlaimmvaccordionState(0, null)) {
    on<KlaimmvaccordionToggleEvent>(onToggle);
  }

  Future<void> onToggle(KlaimmvaccordionToggleEvent event, Emitter<KlaimmvaccordionState> emit) async {
    int? newOpenedIndex = state.openedIndex == event.index ? null : event.index;
    emit(state.copyWith(openedIndex: newOpenedIndex, previousIndex: state.openedIndex));
  }
}