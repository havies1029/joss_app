
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regrenewal/regrenewal2cari_model.dart';
import 'package:joss_app/repositories/regrenewal/regrenewal2cari_repository.dart';

part 'regrenewal2cari_event.dart';
part 'regrenewal2cari_state.dart';

class Regrenewal2CariBloc extends Bloc<Regrenewal2CariEvents, Regrenewal2CariState> {
	Regrenewal2CariBloc() : super(const Regrenewal2CariState()) {
		on<FetchRegrenewal2CariEvent>(onFetchRegrenewal2Cari);
		on<RefreshRegrenewal2CariEvent>(onRefreshRegrenewal2Cari);
	}
  
Future<void> onRefreshRegrenewal2Cari(
		RefreshRegrenewal2CariEvent event, Emitter<Regrenewal2CariState> emit) async {
	emit(const Regrenewal2CariState());

  emit(state.copyWith(regrenew1Id: event.regrenew1Id));

	add(FetchRegrenewal2CariEvent());
}

Future<void> onFetchRegrenewal2Cari(
		FetchRegrenewal2CariEvent event, Emitter<Regrenewal2CariState> emit) async {
	if (state.hasReachedMax) return;

	Regrenewal2CariRepository repo = Regrenewal2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regrenewal2CariModel> items = await repo.getRegrenewal2Cari(state.regrenew1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<Regrenewal2CariModel> items = await repo.getRegrenewal2Cari(state.regrenew1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Regrenewal2CariModel> regrenewal2Cari = List.of(state.items)..addAll(items);

		final result = regrenewal2Cari
			.whereWithIndex((e, index) =>
				regrenewal2Cari.indexWhere((e2) => e2.regrenew2Id == e.regrenew2Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}
}