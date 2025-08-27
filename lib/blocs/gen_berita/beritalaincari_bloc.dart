import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_berita/berita1cari_model.dart';
import 'package:joss_app/repositories/gen_berita/berita1cari_repository.dart';

part 'beritalaincari_event.dart';
part 'beritalaincari_state.dart';

class BeritaLainCariBloc extends Bloc<BeritaLainCariEvents, BeritaLainCariState> {
	BeritaLainCariBloc() : super(const BeritaLainCariState()) {
		on<FetchBeritaLainCariEvent>(onFetchBeritaLainCari);
		on<RefreshBeritaLainCariEvent>(onRefreshBeritaLainCari);
	}

	Future<void> onRefreshBeritaLainCari(
			RefreshBeritaLainCariEvent event, Emitter<BeritaLainCariState> emit) async {
		emit(const BeritaLainCariState());
		emit(state.copyWith(

			hal: 0,
			jenis: event.jenis,
			berita1Id: event.berita1Id, // ⬅️ SIMPAN ID KE STATE DI SINI!
		));

		add(FetchBeritaLainCariEvent());
	}

	Future<void> onFetchBeritaLainCari(
			FetchBeritaLainCariEvent event, Emitter<BeritaLainCariState> emit) async {
		if (state.hasReachedMax) return;

		Berita1CariRepository repo = Berita1CariRepository();

		if (state.status == ListStatus.initial) {
			List<Berita1CariModel> items = await repo.getBerita1Cari(state.jenis, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));
		}

		List<Berita1CariModel> items =
		await repo.getBerita1Cari(state.jenis, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Berita1CariModel> berita1Cari =
			List.of(state.items)..addAll(items);

			final result = berita1Cari
					.whereWithIndex((e, index) =>
			berita1Cari.indexWhere((e2) => e2.berita1Id == e.berita1Id) ==
					index)
					.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
			));
		}
	}
}
