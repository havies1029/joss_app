import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gallery/gallerymembercari_model.dart';
import 'package:joss_app/repositories/gallery/gallerymembercari_repository.dart';

part 'gallerymembercari_event.dart';
part 'gallerymembercari_state.dart';

class GallerymemberCariBloc extends Bloc<GallerymemberCariEvents, GallerymemberCariState> {
	GallerymemberCariBloc() : super(const GallerymemberCariState()) {
		on<FetchGallerymemberCariEvent>(onFetchGallerymemberCari);
		on<RefreshGallerymemberCariEvent>(onRefreshGallerymemberCari);
	}

Future<void> onRefreshGallerymemberCari(
		RefreshGallerymemberCariEvent event, Emitter<GallerymemberCariState> emit) async {
	emit(const GallerymemberCariState());

	add(FetchGallerymemberCariEvent());
}

Future<void> onFetchGallerymemberCari(
		FetchGallerymemberCariEvent event, Emitter<GallerymemberCariState> emit) async {
	if (state.hasReachedMax) return;

	GallerymemberCariRepository repo = GallerymemberCariRepository();
	if (state.status == ListStatus.initial) {
		List<GallerymemberCariModel> items = await repo.getGallerymemberCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<GallerymemberCariModel> items = await repo.getGallerymemberCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<GallerymemberCariModel> gallerymemberCari = List.of(state.items)..addAll(items);

		final result = gallerymemberCari
			.whereWithIndex((e, index) =>
				gallerymemberCari.indexWhere((e2) => e2.gallerymemberId == e.gallerymemberId) ==
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