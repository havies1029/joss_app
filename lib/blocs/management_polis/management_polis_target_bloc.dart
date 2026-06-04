import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'management_polis_target_event.dart';
part 'management_polis_target_state.dart';

class ManagementPolisTargetBloc
    extends Bloc<ManagementPolisTargetEvents, ManagementPolisTargetState> {
  ManagementPolisTargetBloc() : super(const ManagementPolisTargetState()) {
    on<SetManagementPolisTargetEvent>(onSetManagementPolisTarget);
    on<ConsumeManagementPolisTargetEvent>(onConsumeManagementPolisTarget);
  }

  Future<void> onSetManagementPolisTarget(
      SetManagementPolisTargetEvent event,
      Emitter<ManagementPolisTargetState> emit,
      ) async {
    emit(state.copyWith(
      cobId: event.cobId,
      statusId: event.statusId,
      consumed: false,
    ));
  }

  Future<void> onConsumeManagementPolisTarget(
      ConsumeManagementPolisTargetEvent event,
      Emitter<ManagementPolisTargetState> emit,
      ) async {
    emit(const ManagementPolisTargetState());
  }
}