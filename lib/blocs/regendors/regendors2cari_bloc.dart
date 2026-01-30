import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regendors/regendors2cari_model.dart';
import 'package:joss_app/repositories/regendors/regendors2cari_repository.dart';

part 'regendors2cari_event.dart';
part 'regendors2cari_state.dart';

class Regendors2CariBloc extends Bloc<Regendors2CariEvents, Regendors2CariState> {
	Regendors2CariBloc() : super(const Regendors2CariState()) {
		on<FetchRegendors2CariEvent>(onFetchRegendors2Cari);
		on<RefreshRegendors2CariEvent>(onRefreshRegendors2Cari);
	}

Future<void> onRefreshRegendors2Cari(
		RefreshRegendors2CariEvent event, Emitter<Regendors2CariState> emit) async {
	emit(const Regendors2CariState());
  emit(state.copyWith(regendors1Id: event.regendors1Id));
	add(FetchRegendors2CariEvent());
}

Future<void> onFetchRegendors2Cari(
		FetchRegendors2CariEvent event, Emitter<Regendors2CariState> emit) async {
	if (state.hasReachedMax) return;

	Regendors2CariRepository repo = Regendors2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regendors2CariModel> items = await repo.getRegendors2Cari(state.regendors1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<Regendors2CariModel> items = await repo.getRegendors2Cari(state.regendors1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Regendors2CariModel> regendors2Cari = List.of(state.items)..addAll(items);

		final result = regendors2Cari
			.whereWithIndex((e, index) =>
				regendors2Cari.indexWhere((e2) => e2.regendors2Id == e.regendors2Id) ==
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