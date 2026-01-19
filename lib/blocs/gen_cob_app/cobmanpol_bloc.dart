import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_cob_app/cobcari_model.dart';
import 'package:joss_app/repositories/gen_cob_app/cobcari_repository.dart';

part 'cobmanpol_event.dart';
part 'cobmanpol_state.dart';

class CobManPolBloc extends Bloc<CobManPolEvents, CobManPolState> {
  CobManPolBloc() : super(const CobManPolState()) {
    on<FetchCobManPolEvent>(onFetchCobManPol);
    on<RefreshCobManPolEvent>(onRefreshCobManPol);
    on<SelectButton>(onSelectButton);
  }

  Future<void> onRefreshCobManPol(
      RefreshCobManPolEvent event, Emitter<CobManPolState> emit) async {
    emit(const CobManPolState());

    add(FetchCobManPolEvent());
  }

  Future<void> onFetchCobManPol(
      FetchCobManPolEvent event, Emitter<CobManPolState> emit) async {
    if (state.hasReachedMax) return;

    CobCariRepository repo = CobCariRepository();
    if (state.status == ListStatus.initial) {
      List<CobCariModel> items = await repo.getCobManPolCari();
      return emit(state.copyWith(
        items: items,
        hasReachedMax: false,
        status: ListStatus.success,
      ));
    }
    List<CobCariModel> items = await repo.getCobManPolCari();
    if (items.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      List<CobCariModel> cobCari = List.of(state.items)..addAll(items);

      final result = cobCari
          .whereWithIndex((e, index) =>
      cobCari.indexWhere((e2) => e2.mCobApp1Id == e.mCobApp1Id) ==
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
      SelectButton event, Emitter<CobManPolState> emit) async {
    emit(state.copyWith(
      selectedCOBId: event.id,
    ));
  }
}
