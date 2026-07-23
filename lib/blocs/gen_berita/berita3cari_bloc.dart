import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_berita/berita3cari_model.dart';
import 'package:joss_app/repositories/gen_berita/berita3cari_repository.dart';

part 'berita3cari_event.dart';
part 'berita3cari_state.dart';

class Berita3CariBloc extends Bloc<Berita3CariEvents, Berita3CariState> {
  Berita3CariBloc() : super(const Berita3CariState()) {
    on<FetchBerita3CariEvent>(onFetchBerita3Cari);
    on<RefreshBerita3CariEvent>(onRefreshBerita3Cari);
  }

  Future<void> onRefreshBerita3Cari(
    RefreshBerita3CariEvent event,
    Emitter<Berita3CariState> emit,
  ) async {
    final cachedItems = state.cache[event.berita1Id];
    if (cachedItems != null) {
      emit(state.copyWith(
        berita1Id: event.berita1Id,
        items: cachedItems,
        hasReachedMax: true,
        status: ListStatus.success,
      ));
      return;
    }

    emit(state.copyWith(
      berita1Id: event.berita1Id,
      items: const <Berita3CariModel>[],
      hasReachedMax: false,
      status: ListStatus.initial,
    ));
    add(FetchBerita3CariEvent(berita1Id: event.berita1Id));
  }

  Future<void> onFetchBerita3Cari(
    FetchBerita3CariEvent event,
    Emitter<Berita3CariState> emit,
  ) async {
    if (state.hasReachedMax) return;

    Berita3CariRepository repo = Berita3CariRepository();
    if (state.status == ListStatus.initial) {
      try {
        List<Berita3CariModel> items =
            await repo.getBerita3Cari(event.berita1Id);
        final cache = Map<String, List<Berita3CariModel>>.of(state.cache)
          ..[event.berita1Id] = items;
        if (state.berita1Id != event.berita1Id) {
          return emit(state.copyWith(cache: cache));
        }
        return emit(state.copyWith(
          items: items,
          cache: cache,
          hasReachedMax: true,
          status: ListStatus.success,
        ));
      } catch (_) {
        if (state.berita1Id == event.berita1Id) {
          return emit(state.copyWith(status: ListStatus.failure));
        }
      }
    }
  }
}
