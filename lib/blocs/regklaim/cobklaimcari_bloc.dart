import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regklaim/cobklaimcari_model.dart';
import 'package:joss_app/repositories/regklaim/cobklaimcari_repository.dart';

part 'cobklaimcari_event.dart';
part 'cobklaimcari_state.dart';

class CobklaimcariBloc extends Bloc<CobklaimcariEvents, CobklaimcariState> {
	CobklaimcariBloc() : super(const CobklaimcariState()) {
		on<FetchCobklaimcariEvent>(onFetchCobklaimcari);
		on<RefreshCobklaimcariEvent>(onRefreshCobklaimcari);
    on<CobklaimcariItemSelectedEvent>(onCobklaimcariItemSelected);
	}

Future<void> onRefreshCobklaimcari(
		RefreshCobklaimcariEvent event, Emitter<CobklaimcariState> emit) async {
	emit(const CobklaimcariState());

	add(FetchCobklaimcariEvent());
}

Future<void> onFetchCobklaimcari(
		FetchCobklaimcariEvent event, Emitter<CobklaimcariState> emit) async {
	if (state.hasReachedMax) return;

	CobklaimcariRepository repo = CobklaimcariRepository();
	if (state.status == ListStatus.initial) {
		List<CobklaimcariModel> items = await repo.getCobklaimcari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<CobklaimcariModel> items = await repo.getCobklaimcari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<CobklaimcariModel> cobklaimcari = List.of(state.items)..addAll(items);

		final result = cobklaimcari
			.whereWithIndex((e, index) =>
				cobklaimcari.indexWhere((e2) => e2.mcobklaim1Id == e.mcobklaim1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}

  Future<void> onCobklaimcariItemSelected(
    CobklaimcariItemSelectedEvent event, Emitter<CobklaimcariState> emit) async {
    emit(state.copyWith(selectedItem: event.selectedItem));
  }
}