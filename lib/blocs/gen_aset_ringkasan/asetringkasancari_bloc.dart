import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
import 'package:joss_app/repositories/gen_aset_ringkasan/asetringkasancari_repository.dart';

part 'asetringkasancari_event.dart';
part 'asetringkasancari_state.dart';

class AsetRingkasanCariBloc
    extends Bloc<AsetRingkasanCariEvents, AsetRingkasanCariState> {
  AsetRingkasanCariBloc() : super(const AsetRingkasanCariState()) {
    on<FetchAsetRingkasanCariEvent>(onFetchAsetRingkasanCari);
    on<RefreshAsetRingkasanCariEvent>(onRefreshAsetRingkasanCari);
  }

  Future<void> onRefreshAsetRingkasanCari(RefreshAsetRingkasanCariEvent event,
      Emitter<AsetRingkasanCariState> emit) async {
    emit(const AsetRingkasanCariState());

    emit(state.copyWith(searchText: event.searchText, statusId: event.statusId));

    add(FetchAsetRingkasanCariEvent());
  }

  Future<void> onFetchAsetRingkasanCari(FetchAsetRingkasanCariEvent event,
      Emitter<AsetRingkasanCariState> emit) async {
    if (state.hasReachedMax) return;

    AsetRingkasanCariRepository repo = AsetRingkasanCariRepository();
    if (state.status == ListStatus.initial) {
      List<AsetRingkasanCariModel> items =
      await repo.getAsetRingkasanCari(state.statusId, state.searchText, 0);
      return emit(state.copyWith(
          items: items,
          hasReachedMax: false,
          status: ListStatus.success,
          hal: 1));
    }
    List<AsetRingkasanCariModel> items =
    await repo.getAsetRingkasanCari(state.statusId, state.searchText, state.hal);
    if (items.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      List<AsetRingkasanCariModel> asetRingkasanCari = List.of(state.items)
        ..addAll(items);

      final result = asetRingkasanCari
          .whereWithIndex((e, index) =>
      asetRingkasanCari.indexWhere(
              (e2) => e2.asetRingkasanId == e.asetRingkasanId) ==
          index)
          .toList();

      return emit(state.copyWith(
          items: result,
          hasReachedMax: false,
          status: ListStatus.success,
          hal: state.hal + 1));
    }
  }
}