import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimringkas/mstatusringkascari_model.dart';

part 'mstatusringkascari_event.dart';
part 'mstatusringkascari_state.dart';

class MstatusringkasCariBloc extends Bloc<MstatusringkasCariEvents, MstatusringkasCariState> {
	MstatusringkasCariBloc() : super(const MstatusringkasCariState()) {
    on<SelectedIdChanged>(onSelectedIdChanged);
	}


  Future<void> onSelectedIdChanged(
      SelectedIdChanged event,
      Emitter<MstatusringkasCariState> emit,
      ) async {

    debugPrint("===== STATUS CHANGED =====");
    debugPrint("OLD: ${state.selectedStatusId}");
    debugPrint("NEW: ${event.selectedId}");
    debugPrint("==========================");

    emit(state.copyWith(
      selectedStatusId: event.selectedId,
    ));
  }
}