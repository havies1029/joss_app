import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_health/sppa2healthcari_model.dart';
import 'package:joss_app/repositories/gen_aset_health/sppa2healthcari_repository.dart';

part 'sppa2healthcari_event.dart';
part 'sppa2healthcari_state.dart';

class Sppa2healthCariBloc extends Bloc<Sppa2healthCariEvents, Sppa2healthCariState> {
	Sppa2healthCariBloc() : super(const Sppa2healthCariState()) {
		on<FetchSppa2healthCariEvent>(onFetchSppa2healthCari);
		on<RefreshSppa2healthCariEvent>(onRefreshSppa2healthCari);
	}

Future<void> onRefreshSppa2healthCari(
		RefreshSppa2healthCariEvent event, Emitter<Sppa2healthCariState> emit) async {
	emit(const Sppa2healthCariState());

  emit(state.copyWith(
    searchText: event.searchText,
    sppa1Id: event.sppa1Id,
  ));

	add(FetchSppa2healthCariEvent());
}

Future<void> onFetchSppa2healthCari(
		FetchSppa2healthCariEvent event, Emitter<Sppa2healthCariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2healthCariRepository repo = Sppa2healthCariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2healthCariModel> items = await repo.getSppa2healthCari(state.sppa1Id, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2healthCariModel> items = await repo.getSppa2healthCari(state.sppa1Id, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2healthCariModel> sppa2healthCari = List.of(state.items)..addAll(items);

		final result = sppa2healthCari
			.whereWithIndex((e, index) =>
				sppa2healthCari.indexWhere((e2) => e2.sppa2healthId == e.sppa2healthId) ==
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