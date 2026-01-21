import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/asetothers/asetotherscari_model.dart';
import 'package:joss_app/repositories/asetothers/asetotherscari_repository.dart';

part 'asetotherscari_event.dart';
part 'asetotherscari_state.dart';

class AsetothersCariBloc extends Bloc<AsetothersCariEvents, AsetothersCariState> {
	AsetothersCariBloc() : super(const AsetothersCariState()) {
		on<FetchAsetothersCariEvent>(onFetchAsetothersCari);
		on<RefreshAsetothersCariEvent>(onRefreshAsetothersCari);
		on<SelectOthersDetailEvent>(onSelectDetail);
		on<UnselectOthersDetailEvent>(onUnselectDetail);
		on<ClearOthersSelectionEvent>(onClearSelection);

		on<SelectPolisOthersDetailEvent>(onSelectPolisOthersDetail);
		on<UnselectPolisOthersDetailEvent>(onUnselectPolisOthersDetail);
		on<ClearPolisOthersSelectionEvent>(onClearPolisOthersSelection);
	}

Future<void> onRefreshAsetothersCari(
		RefreshAsetothersCariEvent event, Emitter<AsetothersCariState> emit) async {
	emit(const AsetothersCariState());
  emit(state.copyWith(statusId: event.statusId, cobId: event.cobId, searchText: event.searchText));
	add(FetchAsetothersCariEvent());
}

Future<void> onFetchAsetothersCari(
		FetchAsetothersCariEvent event, Emitter<AsetothersCariState> emit) async {
	if (state.hasReachedMax) return;

	AsetothersCariRepository repo = AsetothersCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsetothersCariModel> items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<AsetothersCariModel> items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsetothersCariModel> asetothersCari = List.of(state.items)..addAll(items);

		final result = asetothersCari
			.whereWithIndex((e, index) =>
				asetothersCari.indexWhere((e2) => e2.asetOthersId == e.asetOthersId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}
	}

	Future<void> onSelectDetail(
			SelectOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..add(event.asetOthersId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onUnselectDetail(
			UnselectOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..remove(event.asetOthersId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onClearSelection(
			ClearOthersSelectionEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;
		emit(state.copyWith(selectedIds: <String>{}));
	}


	Future<void> onSelectPolisOthersDetail(
			SelectPolisOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		emit(state.copyWith(
			selectedFilePolisId: event.filePolisId,
		));
	}

	Future<void> onUnselectPolisOthersDetail(
			UnselectPolisOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		emit(state.copyWith(
			selectedFilePolisId: "",
		));
	}

	Future<void> onClearPolisOthersSelection(
			ClearPolisOthersSelectionEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.selectedFilePolisId.isEmpty) return;
		emit(state.copyWith(
			selectedFilePolisId: "",
		));
	}
}