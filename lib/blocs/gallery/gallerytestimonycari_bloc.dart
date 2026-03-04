import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gallery/gallerytestimonycari_model.dart';
import 'package:joss_app/repositories/gallery/gallerytestimonycari_repository.dart';

part 'gallerytestimonycari_event.dart';
part 'gallerytestimonycari_state.dart';

class GallerytestimonyCariBloc extends Bloc<GallerytestimonyCariEvents, GallerytestimonyCariState> {
	GallerytestimonyCariBloc() : super(const GallerytestimonyCariState()) {
		on<FetchGallerytestimonyCariEvent>(onFetchGallerytestimonyCari);
		on<RefreshGallerytestimonyCariEvent>(onRefreshGallerytestimonyCari);
	}

Future<void> onRefreshGallerytestimonyCari(
		RefreshGallerytestimonyCariEvent event, Emitter<GallerytestimonyCariState> emit) async {
	emit(const GallerytestimonyCariState());

	add(FetchGallerytestimonyCariEvent());
}

Future<void> onFetchGallerytestimonyCari(
		FetchGallerytestimonyCariEvent event, Emitter<GallerytestimonyCariState> emit) async {
	if (state.hasReachedMax) return;

	GallerytestimonyCariRepository repo = GallerytestimonyCariRepository();
	if (state.status == ListStatus.initial) {
		List<GallerytestimonyCariModel> items = await repo.getGallerytestimonyCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<GallerytestimonyCariModel> items = await repo.getGallerytestimonyCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<GallerytestimonyCariModel> gallerytestimonyCari = List.of(state.items)..addAll(items);

		final result = gallerytestimonyCari
			.whereWithIndex((e, index) =>
				gallerytestimonyCari.indexWhere((e2) => e2.gallerytestimonyId == e.gallerytestimonyId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}
}