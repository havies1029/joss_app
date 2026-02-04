import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_status_aset/statusasetcari_model.dart';
import 'package:joss_app/repositories/gen_status_aset/statusasetcari_repository.dart';

part 'statusasetcari_event.dart';
part 'statusasetcari_state.dart';

class StatusAsetCariBloc extends Bloc<StatusAsetCariEvents, StatusAsetCariState> {
	StatusAsetCariBloc() : super(const StatusAsetCariState()) {
		on<FetchStatusAsetCariEvent>(onFetchStatusAsetCari);
		on<RefreshStatusAsetCariEvent>(onRefreshStatusAsetCari);
    on<SelectButton>(onSelectButton);
	}

Future<void> onRefreshStatusAsetCari(
		RefreshStatusAsetCariEvent event, Emitter<StatusAsetCariState> emit) async {
	emit(const StatusAsetCariState());

	add(FetchStatusAsetCariEvent());
}

Future<void> onFetchStatusAsetCari(
		FetchStatusAsetCariEvent event, Emitter<StatusAsetCariState> emit) async {
	if (state.hasReachedMax) return;

	StatusAsetCariRepository repo = StatusAsetCariRepository();
	if (state.status == ListStatus.initial) {
		List<StatusAsetCariModel> items = await repo.getStatusAsetCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<StatusAsetCariModel> items = await repo.getStatusAsetCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<StatusAsetCariModel> statusAsetCari = List.of(state.items)..addAll(items);

		final result = statusAsetCari
			.whereWithIndex((e, index) =>
				statusAsetCari.indexWhere((e2) => e2.mstatusasetId == e.mstatusasetId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}

	Future<void> onSelectButton(
			SelectButton event, Emitter<StatusAsetCariState> emit) async {

		if (event.id == state.selectedStatusId) return;

		emit(state.copyWith(
			selectedStatusId: event.id,
			statusChangeTick: state.statusChangeTick + 1,
		));
	}
}