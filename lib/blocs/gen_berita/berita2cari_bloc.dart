import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_berita/berita2cari_model.dart';
import 'package:joss_app/repositories/gen_berita/berita2cari_repository.dart';

part 'berita2cari_event.dart';
part 'berita2cari_state.dart';

class Berita2CariBloc extends Bloc<Berita2CariEvents, Berita2CariState> {
	Berita2CariBloc() : super(const Berita2CariState()) {
		on<FetchBerita2CariEvent>(onFetchBerita2Cari);
		on<RefreshBerita2CariEvent>(onRefreshBerita2Cari);
	}

Future<void> onRefreshBerita2Cari(
		RefreshBerita2CariEvent event, Emitter<Berita2CariState> emit) async {
	emit(const Berita2CariState());

  emit(state.copyWith(berita1Id: event.berita1Id));

	add(FetchBerita2CariEvent());
}

Future<void> onFetchBerita2Cari(
		FetchBerita2CariEvent event, Emitter<Berita2CariState> emit) async {
	if (state.hasReachedMax) return;

	Berita2CariRepository repo = Berita2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Berita2CariModel> items = await repo.getBerita2Cari(state.berita1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: true,
			status: ListStatus.success,
			));
	  }	

	}
}