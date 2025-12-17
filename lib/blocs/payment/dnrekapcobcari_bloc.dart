import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';
import 'package:joss_app/repositories/payment/dnrekapcobcari_repository.dart';

part 'dnrekapcobcari_event.dart';
part 'dnrekapcobcari_state.dart';

class DnrekapcobCariBloc extends Bloc<DnrekapcobCariEvents, DnrekapcobCariState> {
	DnrekapcobCariBloc() : super(const DnrekapcobCariState()) {
		on<FetchDnrekapcobCariEvent>(onFetchDnrekapcobCari);
		on<RefreshDnrekapcobCariEvent>(onRefreshDnrekapcobCari);
    on<ToggleSelectItemEvent>(onToggleSelectItem);
  }

Future<void> onRefreshDnrekapcobCari(
		RefreshDnrekapcobCariEvent event, Emitter<DnrekapcobCariState> emit) async {
	emit(const DnrekapcobCariState());

	add(FetchDnrekapcobCariEvent());
}

Future<void> onFetchDnrekapcobCari(
		FetchDnrekapcobCariEvent event, Emitter<DnrekapcobCariState> emit) async {
	if (state.hasReachedMax) return;

	DnrekapcobCariRepository repo = DnrekapcobCariRepository();
	if (state.status == ListStatus.initial) {
		List<DnrekapcobCariModel> items = await repo.getDnrekapcobCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<DnrekapcobCariModel> items = await repo.getDnrekapcobCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<DnrekapcobCariModel> dnrekapcobCari = List.of(state.items)..addAll(items);

		final result = dnrekapcobCari
			.whereWithIndex((e, index) =>
				dnrekapcobCari.indexWhere((e2) => e2.dnrekapcobId == e.dnrekapcobId) ==
				index)
			.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				));
		}
	}

  void onToggleSelectItem(
      ToggleSelectItemEvent event, Emitter<DnrekapcobCariState> emit) {

    final selectedIds = Set<String>.from(state.selectedIds);
    debugPrint('Toggling selection for cobId: ${event.cobId}');
    debugPrint('Current selectedIds before toggle: $selectedIds');
    if (selectedIds.contains(event.cobId)) {
      selectedIds.remove(event.cobId);
    } else {
      selectedIds.add(event.cobId);
    }
    emit(state.copyWith(selectedIds: selectedIds));
    debugPrint('Updated selectedIds after toggle: ${state.selectedIds}');
  }

}

