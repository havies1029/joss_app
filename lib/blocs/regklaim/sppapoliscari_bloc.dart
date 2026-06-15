import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regklaim/sppapoliscari_model.dart';
import 'package:joss_app/repositories/regklaim/sppapoliscari_repository.dart';

part 'sppapoliscari_event.dart';
part 'sppapoliscari_state.dart';

class SppapoliscariBloc extends Bloc<SppapoliscariEvents, SppapoliscariState> {
	SppapoliscariBloc() : super(const SppapoliscariState()) {
		on<FetchSppapoliscariEvent>(onFetchSppapoliscari);
		on<RefreshSppapoliscariEvent>(onRefreshSppapoliscari);
	}

Future<void> onRefreshSppapoliscari(
		RefreshSppapoliscariEvent event, Emitter<SppapoliscariState> emit) async {
	emit(const SppapoliscariState());
  emit(state.copyWith(cobKlaimId: event.cobKlaimId, searchText: event.searchText));
	add(FetchSppapoliscariEvent());
} 

Future<void> onFetchSppapoliscari(
		FetchSppapoliscariEvent event, Emitter<SppapoliscariState> emit) async {
	if (state.hasReachedMax) return;

	SppapoliscariRepository repo = SppapoliscariRepository();
	if (state.status == ListStatus.initial) {
		List<SppapoliscariModel> items = await repo.getSppapoliscari(state.cobKlaimId, state.searchText);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1,
			));
	}
	List<SppapoliscariModel> items = await repo.getSppapoliscari(state.cobKlaimId, state.searchText);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<SppapoliscariModel> sppapoliscari = List.of(state.items)..addAll(items);

		final result = sppapoliscari
			.whereWithIndex((e, index) =>
				sppapoliscari.indexWhere((e2) => e2.sppaId == e.sppaId) ==
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