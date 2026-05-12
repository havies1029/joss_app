import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_hull/sppa2hullcari_model.dart';
import 'package:joss_app/repositories/gen_aset_hull/sppa2hullcari_repository.dart';

part 'sppa2hullcari_event.dart';
part 'sppa2hullcari_state.dart';

class Sppa2hullCariBloc extends Bloc<Sppa2hullCariEvents, Sppa2hullCariState> {
	Sppa2hullCariBloc() : super(const Sppa2hullCariState()) {
		on<FetchSppa2hullCariEvent>(onFetchSppa2hullCari);
		on<RefreshSppa2hullCariEvent>(onRefreshSppa2hullCari);
	}

Future<void> onRefreshSppa2hullCari(
		RefreshSppa2hullCariEvent event, Emitter<Sppa2hullCariState> emit) async {
	emit(const Sppa2hullCariState());

  emit(state.copyWith(searchText: event.searchText, sppa1Id: event.sppa1Id));

	add(FetchSppa2hullCariEvent());
}

Future<void> onFetchSppa2hullCari(
		FetchSppa2hullCariEvent event, Emitter<Sppa2hullCariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2hullCariRepository repo = Sppa2hullCariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2hullCariModel> items = await repo.getSppa2hullCari(state.sppa1Id, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2hullCariModel> items = await repo.getSppa2hullCari(state.sppa1Id, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2hullCariModel> sppa2hullCari = List.of(state.items)..addAll(items);

		final result = sppa2hullCari
			.whereWithIndex((e, index) =>
				sppa2hullCari.indexWhere((e2) => e2.sppa2hullId == e.sppa2hullId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}

	}
}