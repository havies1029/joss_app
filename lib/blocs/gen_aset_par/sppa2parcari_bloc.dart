import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_par/sppa2parcari_model.dart';
import 'package:joss_app/repositories/gen_aset_par/sppa2parcari_repository.dart';

part 'sppa2parcari_event.dart';
part 'sppa2parcari_state.dart';

class Sppa2parCariBloc extends Bloc<Sppa2parCariEvents, Sppa2parCariState> {
	Sppa2parCariBloc() : super(const Sppa2parCariState()) {
		on<FetchSppa2parCariEvent>(onFetchSppa2parCari);
		on<RefreshSppa2parCariEvent>(onRefreshSppa2parCari);
	}

Future<void> onRefreshSppa2parCari(
		RefreshSppa2parCariEvent event, Emitter<Sppa2parCariState> emit) async {
	emit(const Sppa2parCariState());
  
  emit(state.copyWith(searchText: event.searchText, sppa1Id: event.sppa1Id));

	add(FetchSppa2parCariEvent());
}

Future<void> onFetchSppa2parCari(
		FetchSppa2parCariEvent event, Emitter<Sppa2parCariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2parCariRepository repo = Sppa2parCariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2parCariModel> items = await repo.getSppa2parCari(state.sppa1Id, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2parCariModel> items = await repo.getSppa2parCari(state.sppa1Id, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2parCariModel> sppa2parCari = List.of(state.items)..addAll(items);

		final result = sppa2parCari
			.whereWithIndex((e, index) =>
				sppa2parCari.indexWhere((e2) => e2.sppa2parId == e.sppa2parId) ==
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