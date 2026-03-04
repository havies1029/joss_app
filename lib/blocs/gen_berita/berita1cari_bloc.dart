import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_berita/berita1cari_model.dart';
import 'package:joss_app/repositories/gen_berita/berita1cari_repository.dart';

part 'berita1cari_event.dart';
part 'berita1cari_state.dart';

class Berita1CariBloc extends Bloc<Berita1CariEvents, Berita1CariState> {
	Berita1CariBloc() : super(const Berita1CariState()) {
		on<FetchBerita1CariEvent>(onFetchBerita1Cari);
		on<RefreshBerita1CariEvent>(onRefreshBerita1Cari);
	}

Future<void> onRefreshBerita1Cari(
		RefreshBerita1CariEvent event, Emitter<Berita1CariState> emit) async {
	emit(const Berita1CariState());

  emit(state.copyWith(hal: 0, jenis: event.jenis, berita1Id: event.berita1Id, ));

	add(FetchBerita1CariEvent());
}

Future<void> onFetchBerita1Cari(
		FetchBerita1CariEvent event, Emitter<Berita1CariState> emit) async {
	if (state.hasReachedMax) return;

	Berita1CariRepository repo = Berita1CariRepository();
	if (state.status == ListStatus.initial) {
		List<Berita1CariModel> items = await repo.getBerita1Cari(state.jenis, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1
			));
	}
	List<Berita1CariModel> items = await repo.getBerita1Cari(state.jenis, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Berita1CariModel> berita1Cari = List.of(state.items)..addAll(items);

		final result = berita1Cari
			.whereWithIndex((e, index) =>
				berita1Cari.indexWhere((e2) => e2.berita1Id == e.berita1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1
			));
		}

	}
}