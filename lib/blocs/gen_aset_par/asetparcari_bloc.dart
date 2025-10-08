import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';
import 'package:joss_app/repositories/gen_aset_par/asetparcari_repository.dart';

part 'asetparcari_event.dart';
part 'asetparcari_state.dart';

class AsetParCariBloc extends Bloc<AsetParCariEvents, AsetParCariState> {
	AsetParCariBloc() : super(const AsetParCariState()) {
		on<FetchAsetParCariEvent>(onFetchAsetParCari);
		on<RefreshAsetParCariEvent>(onRefreshAsetParCari);
	}

Future<void> onRefreshAsetParCari(
		RefreshAsetParCariEvent event, Emitter<AsetParCariState> emit) async {
	emit(AsetParCariState(
		items: const [],
		status: ListStatus.initial,
		hal: 0,
		searchText: event.searchText,
		statusId: event.statusId,
		hasReachedMax: false,
	));
  emit(state.copyWith( searchText: event.searchText, hal: 0, statusId: event.statusId));

	add(FetchAsetParCariEvent());
}

Future<void> onFetchAsetParCari(
		FetchAsetParCariEvent event, Emitter<AsetParCariState> emit) async {
	if (state.hasReachedMax) return;

	AsetParCariRepository repo = AsetParCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsetParCariModel> items = await repo.getAsetParCari(state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<AsetParCariModel> items = await repo.getAsetParCari(state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsetParCariModel> asetParCari = List.of(state.items)..addAll(items);

		final result = asetParCari
			.whereWithIndex((e, index) =>
				asetParCari.indexWhere((e2) => e2.asetParId == e.asetParId) ==
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