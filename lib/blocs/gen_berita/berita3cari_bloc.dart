import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
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
		RefreshBerita3CariEvent event, Emitter<Berita3CariState> emit) async {
	emit(const Berita3CariState());

  emit(state.copyWith(berita1Id: event.berita1Id));
	add(FetchBerita3CariEvent());
}

Future<void> onFetchBerita3Cari(
		FetchBerita3CariEvent event, Emitter<Berita3CariState> emit) async {
	if (state.hasReachedMax) return;

	Berita3CariRepository repo = Berita3CariRepository();
	if (state.status == ListStatus.initial) {
		List<Berita3CariModel> items = await repo.getBerita3Cari(state.berita1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: true,
			status: ListStatus.success,
			));
	  }

	}
}