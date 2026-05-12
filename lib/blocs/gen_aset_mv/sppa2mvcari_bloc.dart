import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_mv/sppa2mvcari_model.dart';
import 'package:joss_app/repositories/gen_aset_mv/sppa2mvcari_repository.dart';

part 'sppa2mvcari_event.dart';
part 'sppa2mvcari_state.dart';

class Sppa2mvCariBloc extends Bloc<Sppa2mvCariEvents, Sppa2mvCariState> {
	Sppa2mvCariBloc() : super(const Sppa2mvCariState()) {
		on<FetchSppa2mvCariEvent>(onFetchSppa2mvCari);
		on<RefreshSppa2mvCariEvent>(onRefreshSppa2mvCari);
	}

Future<void> onRefreshSppa2mvCari(
		RefreshSppa2mvCariEvent event, Emitter<Sppa2mvCariState> emit) async {
	emit(const Sppa2mvCariState());

  emit(state.copyWith(
    searchText: event.searchText,
    sppa1Id: event.sppa1Id,
  ));

	add(FetchSppa2mvCariEvent());
}

Future<void> onFetchSppa2mvCari(
		FetchSppa2mvCariEvent event, Emitter<Sppa2mvCariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2mvCariRepository repo = Sppa2mvCariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2mvCariModel> items = await repo.getSppa2mvCari(state.sppa1Id, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2mvCariModel> items = await repo.getSppa2mvCari(state.sppa1Id, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2mvCariModel> sppa2mvCari = List.of(state.items)..addAll(items);

		final result = sppa2mvCari
			.whereWithIndex((e, index) =>
				sppa2mvCari.indexWhere((e2) => e2.sppa2mvId == e.sppa2mvId) ==
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