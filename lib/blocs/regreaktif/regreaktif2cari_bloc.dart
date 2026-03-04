import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regreaktif/regreaktif2cari_model.dart';
import 'package:joss_app/repositories/regreaktif/regreaktif2cari_repository.dart';

part 'regreaktif2cari_event.dart';
part 'regreaktif2cari_state.dart';

class Regreaktif2CariBloc extends Bloc<Regreaktif2CariEvents, Regreaktif2CariState> {
	Regreaktif2CariBloc() : super(const Regreaktif2CariState()) {
		on<FetchRegreaktif2CariEvent>(onFetchRegreaktif2Cari);
		on<RefreshRegreaktif2CariEvent>(onRefreshRegreaktif2Cari);
	}

Future<void> onRefreshRegreaktif2Cari(
		RefreshRegreaktif2CariEvent event, Emitter<Regreaktif2CariState> emit) async {
	emit(const Regreaktif2CariState());
  emit(state.copyWith(regreaktif1Id: event.regreaktif1Id));
	add(FetchRegreaktif2CariEvent());
}

Future<void> onFetchRegreaktif2Cari(
		FetchRegreaktif2CariEvent event, Emitter<Regreaktif2CariState> emit) async {
	if (state.hasReachedMax) return;

	Regreaktif2CariRepository repo = Regreaktif2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regreaktif2CariModel> items = await repo.getRegreaktif2Cari(state.regreaktif1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<Regreaktif2CariModel> items = await repo.getRegreaktif2Cari(state.regreaktif1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Regreaktif2CariModel> regreaktif2Cari = List.of(state.items)..addAll(items);

		final result = regreaktif2Cari
			.whereWithIndex((e, index) =>
				regreaktif2Cari.indexWhere((e2) => e2.regreaktif2Id == e.regreaktif2Id) ==
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