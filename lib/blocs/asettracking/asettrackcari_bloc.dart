import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';

import '../../models/asettracking/asettrackcari_model.dart';
import '../../repositories/asettracking/asettrackcari_repository.dart';

part 'asettrackcari_event.dart';
part 'asettrackcari_state.dart';

class AsettrackCariBloc extends Bloc<AsettrackCariEvents, AsettrackCariState> {
	AsettrackCariBloc() : super(const AsettrackCariState()) {
		on<FetchAsettrackCariEvent>(onFetchAsettrackCari);
		on<RefreshAsettrackCariEvent>(onRefreshAsettrackCari);
	}

Future<void> onRefreshAsettrackCari(
		RefreshAsettrackCariEvent event, Emitter<AsettrackCariState> emit) async {
	emit(const AsettrackCariState());

	add(FetchAsettrackCariEvent());
}

Future<void> onFetchAsettrackCari(
		FetchAsettrackCariEvent event, Emitter<AsettrackCariState> emit) async {
	if (state.hasReachedMax) return;

	AsettrackCariRepository repo = AsettrackCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsettrackCariModel> items = await repo.getAsettrackCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<AsettrackCariModel> items = await repo.getAsettrackCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsettrackCariModel> asettrackCari = List.of(state.items)..addAll(items);

		final result = asettrackCari
			.whereWithIndex((e, index) =>
				asettrackCari.indexWhere((e2) => e2.prosesId == e.prosesId) ==
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