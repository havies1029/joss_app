import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimringkas/klaimringkascari_model.dart';
import 'package:joss_app/repositories/klaimringkas/klaimringkascari_repository.dart';

part 'klaimringkascari_event.dart';
part 'klaimringkascari_state.dart';

class KlaimringkasCariBloc extends Bloc<KlaimringkasCariEvents, KlaimringkasCariState> {
  KlaimringkasCariBloc() : super(const KlaimringkasCariState()) {
    on<FetchKlaimringkasCariEvent>(onFetchKlaimringkasCari);
    on<RefreshKlaimringkasCariEvent>(onRefreshKlaimringkasCari);
  }

  Future<void> onRefreshKlaimringkasCari(RefreshKlaimringkasCariEvent event,
      Emitter<KlaimringkasCariState> emit,) async {
    if (event.selectedStatusId.isEmpty) return;

    emit(state.copyWith(
      selectedStatusId: event.selectedStatusId,
      status: ListStatus.initial,
      items: <KlaimringkasCariModel>[],
    ));

    add(FetchKlaimringkasCariEvent());
  }

  Future<void> onFetchKlaimringkasCari(FetchKlaimringkasCariEvent event,
      Emitter<KlaimringkasCariState> emit,) async {
    try {
      emit(state.copyWith(status: ListStatus.loadingMore));

      final repo = KlaimringkasCariRepository();
      final items = await repo.getKlaimringkasCari(state.selectedStatusId);

      emit(state.copyWith(
        items: items,
        status: ListStatus.success,
        selectedStatusId: state.selectedStatusId,
      ));
    } catch (e) {
      emit(state.copyWith(status: ListStatus.failure));
    }
  }
}