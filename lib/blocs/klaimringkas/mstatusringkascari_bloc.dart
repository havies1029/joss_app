import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimringkas/mstatusringkascari_model.dart';
import 'package:joss_app/repositories/klaimringkas/mstatusringkascari_repository.dart';

part 'mstatusringkascari_event.dart';
part 'mstatusringkascari_state.dart';

class MstatusringkasCariBloc extends Bloc<MstatusringkasCariEvents, MstatusringkasCariState> {
	MstatusringkasCariBloc() : super(const MstatusringkasCariState()) {
		on<FetchMstatusringkasCariEvent>(onFetchMstatusringkasCari);
		on<RefreshMstatusringkasCariEvent>(onRefreshMstatusringkasCari);
    on<SelectedIdChanged>(onSelectedIdChanged);
	}

Future<void> onRefreshMstatusringkasCari(
		RefreshMstatusringkasCariEvent event, Emitter<MstatusringkasCariState> emit) async {
	emit(const MstatusringkasCariState());
	add(FetchMstatusringkasCariEvent());

}

Future<void> onFetchMstatusringkasCari(
		FetchMstatusringkasCariEvent event, Emitter<MstatusringkasCariState> emit) async {
	if (state.hasReachedMax) return;

	MstatusringkasCariRepository repo = MstatusringkasCariRepository();
    if (state.status == ListStatus.initial) {
      List<MstatusringkasCariModel> items = await repo.getMstatusringkasCari();
      return emit(state.copyWith(
        items: items,
        hasReachedMax: false,
        status: ListStatus.success,
        ));
    }
	}

  Future<void> onSelectedIdChanged(
    SelectedIdChanged event, Emitter<MstatusringkasCariState> emit) async {
      emit(state.copyWith(selectedStatusId: event.selectedId));
  }
	
}