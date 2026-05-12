import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/assetdetail/sppa2cari_model.dart';
import 'package:joss_app/repositories/assetdetail/sppa2cari_repository.dart';

part 'sppa2cari_event.dart';
part 'sppa2cari_state.dart';

class Sppa2CariBloc extends Bloc<Sppa2CariEvents, Sppa2CariState> {
	Sppa2CariBloc() : super(const Sppa2CariState()) {
		on<FetchSppa2CariEvent>(onFetchSppa2Cari);
		on<RefreshSppa2CariEvent>(onRefreshSppa2Cari);
	}

Future<void> onRefreshSppa2Cari(
		RefreshSppa2CariEvent event, Emitter<Sppa2CariState> emit) async {
	emit(const Sppa2CariState());

	add(FetchSppa2CariEvent());
}

Future<void> onFetchSppa2Cari(
		FetchSppa2CariEvent event, Emitter<Sppa2CariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2CariRepository repo = Sppa2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2CariModel> items = await repo.getSppa2Cari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2CariModel> items = await repo.getSppa2Cari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2CariModel> sppa2Cari = List.of(state.items)..addAll(items);

		final result = sppa2Cari
			.whereWithIndex((e, index) =>
				sppa2Cari.indexWhere((e2) => e2.sppa2Id == e.sppa2Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}

	}
}