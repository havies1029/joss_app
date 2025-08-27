import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_aset_dashboard/asetdashboardcari_model.dart';
import 'package:joss_app/repositories/gen_aset_dashboard/asetdashboardcari_repository.dart';

part 'asetdashboardcari_event.dart';
part 'asetdashboardcari_state.dart';

class AsetDashboardCariBloc extends Bloc<AsetDashboardCariEvents, AsetDashboardCariState> {
	AsetDashboardCariBloc() : super(const AsetDashboardCariState()) {
		on<FetchAsetDashboardCariEvent>(onFetchAsetDashboardCari);
		on<RefreshAsetDashboardCariEvent>(onRefreshAsetDashboardCari);
	}

Future<void> onRefreshAsetDashboardCari(
		RefreshAsetDashboardCariEvent event, Emitter<AsetDashboardCariState> emit) async {
	emit(const AsetDashboardCariState());

  emit(state.copyWith(
    status: ListStatus.initial,
    items: const <AsetDashboardCariModel>[],
    hasReachedMax: false,
    cobAppId: event.cobAppId,
  ));

	add(FetchAsetDashboardCariEvent());
}

Future<void> onFetchAsetDashboardCari(
		FetchAsetDashboardCariEvent event, Emitter<AsetDashboardCariState> emit) async {
	if (state.hasReachedMax) return;

	AsetDashboardCariRepository repo = AsetDashboardCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsetDashboardCariModel> items = await repo.getAsetDashboardCari(state.cobAppId);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<AsetDashboardCariModel> items = await repo.getAsetDashboardCari(state.cobAppId);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsetDashboardCariModel> asetDashboardCari = List.of(state.items)..addAll(items);

		return emit(state.copyWith(
			items: asetDashboardCari,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}
}