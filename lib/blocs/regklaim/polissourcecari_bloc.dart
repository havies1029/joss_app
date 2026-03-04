import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regklaim/polissourcecari_model.dart';
import 'package:joss_app/repositories/regklaim/polissourcecari_repository.dart';

part 'polissourcecari_event.dart';
part 'polissourcecari_state.dart';

class PolissourcecariBloc extends Bloc<PolissourcecariEvents, PolissourcecariState> {
	PolissourcecariBloc() : super(const PolissourcecariState()) {
		on<FetchPolissourcecariEvent>(onFetchPolissourcecari);
		on<RefreshPolissourcecariEvent>(onRefreshPolissourcecari);
    on<SelectPolissourcecariEvent>(onSelectPolissourcecari);
	}

Future<void> onRefreshPolissourcecari(
		RefreshPolissourcecariEvent event, Emitter<PolissourcecariState> emit) async {
	emit(const PolissourcecariState());

	add(FetchPolissourcecariEvent());
}

Future<void> onFetchPolissourcecari(
		FetchPolissourcecariEvent event, Emitter<PolissourcecariState> emit) async {
	if (state.hasReachedMax) return;

	PolissourcecariRepository repo = PolissourcecariRepository();
	if (state.status == ListStatus.initial) {
		List<PolissourcecariModel> items = await repo.getPolissourcecari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<PolissourcecariModel> items = await repo.getPolissourcecari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<PolissourcecariModel> polissourcecari = List.of(state.items)..addAll(items);

		final result = polissourcecari
			.whereWithIndex((e, index) =>
				polissourcecari.indexWhere((e2) => e2.polissourceId == e.polissourceId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}

  Future<void> onSelectPolissourcecari(
      SelectPolissourcecariEvent event, Emitter<PolissourcecariState> emit) async {
    emit(state.copyWith(selectedPolissourceId: event.polissourceId));
  }
}