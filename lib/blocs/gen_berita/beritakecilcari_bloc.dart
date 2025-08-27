import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_berita/berita1cari_model.dart';
import 'package:joss_app/repositories/gen_berita/berita1cari_repository.dart';

part 'beritakecilcari_event.dart';
part 'beritakecilcari_state.dart';

class BeritaKecilCariBloc extends Bloc<BeritaKecilCariEvents, BeritaKecilCariState> {
	BeritaKecilCariBloc() : super(const BeritaKecilCariState()) {
		on<FetchBeritaKecilCariEvent>(onFetchBeritaKecilCari);
		on<RefreshBeritaKecilCariEvent>(onRefreshBeritaKecilCari);
	}

	Future<void> onRefreshBeritaKecilCari(
			RefreshBeritaKecilCariEvent event, Emitter<BeritaKecilCariState> emit) async {
		emit(const BeritaKecilCariState());

		emit(state.copyWith(hal: 0, jenis: event.jenis, berita1Id: event.berita1Id, ));

		add(FetchBeritaKecilCariEvent());
	}

	Future<void> onFetchBeritaKecilCari(
			FetchBeritaKecilCariEvent event, Emitter<BeritaKecilCariState> emit) async {
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
