import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gallery/galleryeventcari_model.dart';
import 'package:joss_app/repositories/gallery/galleryeventcari_repository.dart';

part 'galleryeventcari_event.dart';
part 'galleryeventcari_state.dart';

class GalleryeventCariBloc extends Bloc<GalleryeventCariEvents, GalleryeventCariState> {
	GalleryeventCariBloc() : super(const GalleryeventCariState()) {
		on<FetchGalleryeventCariEvent>(onFetchGalleryeventCari);
		on<RefreshGalleryeventCariEvent>(onRefreshGalleryeventCari);
	}

Future<void> onRefreshGalleryeventCari(
		RefreshGalleryeventCariEvent event, Emitter<GalleryeventCariState> emit) async {

  debugPrint("onRefreshGalleryeventCari called");

	emit(const GalleryeventCariState());

	add(FetchGalleryeventCariEvent());
}

Future<void> onFetchGalleryeventCari(
		FetchGalleryeventCariEvent event, Emitter<GalleryeventCariState> emit) async {
	if (state.hasReachedMax) return;

	GalleryeventCariRepository repo = GalleryeventCariRepository();
	if (state.status == ListStatus.initial) {
		List<GalleryeventCariModel> items = await repo.getGalleryeventCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<GalleryeventCariModel> items = await repo.getGalleryeventCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<GalleryeventCariModel> galleryeventCari = List.of(state.items)..addAll(items);

		final result = galleryeventCari
			.whereWithIndex((e, index) =>
				galleryeventCari.indexWhere((e2) => e2.galleryeventId == e.galleryeventId) ==
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