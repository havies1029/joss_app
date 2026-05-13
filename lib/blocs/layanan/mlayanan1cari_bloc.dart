import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/layanan/mlayanan1cari_model.dart';
import 'package:joss_app/repositories/layanan/mlayanan1cari_repository.dart';

part 'mlayanan1cari_event.dart';
part 'mlayanan1cari_state.dart';

class Mlayanan1CariBloc extends Bloc<Mlayanan1CariEvents, Mlayanan1CariState> {
	Mlayanan1CariBloc() : super(const Mlayanan1CariState()) {
		on<FetchMlayanan1CariEvent>(onFetchMlayanan1Cari);
		on<RefreshMlayanan1CariEvent>(onRefreshMlayanan1Cari);
	}

Future<void> onRefreshMlayanan1Cari(
		RefreshMlayanan1CariEvent event, Emitter<Mlayanan1CariState> emit) async {
	emit(const Mlayanan1CariState());
  emit(state.copyWith(mlayanan1Id: state.mlayanan1Id));
	add(FetchMlayanan1CariEvent(mlayanan1Id: state.mlayanan1Id));
}

Future<void> onFetchMlayanan1Cari(
		FetchMlayanan1CariEvent event, Emitter<Mlayanan1CariState> emit) async {
	if (state.hasReachedMax) return;

	Mlayanan1CariRepository repo = Mlayanan1CariRepository();
	if (state.status == ListStatus.initial) {
		List<Mlayanan1CariModel> items = await repo.getMlayanan1Cari(event.mlayanan1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<Mlayanan1CariModel> items = await repo.getMlayanan1Cari(event.mlayanan1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Mlayanan1CariModel> mlayanan1Cari = List.of(state.items)..addAll(items);

		final result = mlayanan1Cari
			.whereWithIndex((e, index) =>
				mlayanan1Cari.indexWhere((e2) => e2.mLayanan1Id == e.mLayanan1Id) ==
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