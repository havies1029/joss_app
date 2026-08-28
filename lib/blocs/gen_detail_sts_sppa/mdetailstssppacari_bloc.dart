import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_detail_sts_sppa/mdetailstssppacari_model.dart';
import 'package:joss_app/repositories/gen_detail_sts_sppa/mdetailstssppacari_repository.dart';
import 'package:joss_app/widgets/list_extension.dart';

part 'mdetailstssppacari_event.dart';
part 'mdetailstssppacari_state.dart';

class MDetailStsSppaCariBloc
    extends Bloc<MDetailStsSppaCariEvents, MDetailStsSppaCariState> {
  MDetailStsSppaCariBloc() : super(const MDetailStsSppaCariState()) {
    on<FetchMDetailStsSppaCariEvent>(onFetchMDetailStsSppaCari);
    on<RefreshMDetailStsSppaCariEvent>(onRefreshMDetailStsSppaCari);
    on<SelectMDetailStsSppaButton>(onSelectButton);
  }

  Future<void> onRefreshMDetailStsSppaCari(
    RefreshMDetailStsSppaCariEvent event,
    Emitter<MDetailStsSppaCariState> emit,
  ) async {
    emit(const MDetailStsSppaCariState());

    add(FetchMDetailStsSppaCariEvent());
  }

  Future<void> onFetchMDetailStsSppaCari(
    FetchMDetailStsSppaCariEvent event,
    Emitter<MDetailStsSppaCariState> emit,
  ) async {
    if (state.hasReachedMax) return;

    MDetailStsSppaCariRepository repo = MDetailStsSppaCariRepository();
    if (state.status == ListStatus.initial) {
      List<MDetailStsSppaCariModel> items = await repo.getMDetailStsSppaCari();
      return emit(state.copyWith(
        items: items,
        hasReachedMax: false,
        status: ListStatus.success,
      ));
    }

    List<MDetailStsSppaCariModel> items = await repo.getMDetailStsSppaCari();
    if (items.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      List<MDetailStsSppaCariModel> mDetailStsSppaCari = List.of(state.items)
        ..addAll(items);

      final result = mDetailStsSppaCari
          .whereWithIndex((e, index) =>
              mDetailStsSppaCari.indexWhere(
                  (e2) => e2.mdetailstssppaId == e.mdetailstssppaId) ==
              index)
          .toList();

      return emit(state.copyWith(
        items: result,
        hasReachedMax: false,
        status: ListStatus.success,
      ));
    }
  }

  Future<void> onSelectButton(
    SelectMDetailStsSppaButton event,
    Emitter<MDetailStsSppaCariState> emit,
  ) async {
    if (event.id == state.selectedDetailStsSppaId) return;

    emit(state.copyWith(
      selectedDetailStsSppaId: event.id,
      statusChangeTick: state.statusChangeTick + 1,
    ));
  }
}
