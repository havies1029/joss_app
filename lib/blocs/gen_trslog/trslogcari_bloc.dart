import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_trslog/trslogcari_model.dart';
import 'package:joss_app/repositories/gen_trslog/trslogcari_repository.dart';

part 'trslogcari_event.dart';
part 'trslogcari_state.dart';

class TrslogCariBloc extends Bloc<TrslogCariEvents, TrslogCariState> {
	TrslogCariBloc() : super(const TrslogCariState()) {
		on<FetchTrslogCariEvent>(onFetchTrslogCari);
		on<RefreshTrslogCariEvent>(onRefreshTrslogCari);
	}

Future<void> onRefreshTrslogCari(
		RefreshTrslogCariEvent event, Emitter<TrslogCariState> emit) async {
	emit(const TrslogCariState());

  
  emit(state.copyWith(searchText: event.searchText));

	add(FetchTrslogCariEvent());
}

Future<void> onFetchTrslogCari(
		FetchTrslogCariEvent event, Emitter<TrslogCariState> emit) async {
	if (state.hasReachedMax) return;

	TrslogCariRepository repo = TrslogCariRepository();
	if (state.status == ListStatus.initial) {
		List<TrslogCariModel> items = await repo.getTrslogCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<TrslogCariModel> items = await repo.getTrslogCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<TrslogCariModel> trslogCari = List.of(state.items)..addAll(items);

		final result = trslogCari
			.whereWithIndex((e, index) =>
				trslogCari.indexWhere((e2) => e2.trslogId == e.trslogId) ==
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