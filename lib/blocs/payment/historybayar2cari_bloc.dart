
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/historybayar2cari_model.dart';
import 'package:joss_app/repositories/payment/historybayar2cari_repository.dart';

part 'historybayar2cari_event.dart';
part 'historybayar2cari_state.dart';

class Historybayar2CariBloc extends Bloc<Historybayar2CariEvents, Historybayar2CariState> {
	Historybayar2CariBloc() : super(const Historybayar2CariState()) {
		on<FetchHistorybayar2CariEvent>(onFetchHistorybayar2Cari);
		on<RefreshHistorybayar2CariEvent>(onRefreshHistorybayar2Cari);
	}

Future<void> onRefreshHistorybayar2Cari(
		RefreshHistorybayar2CariEvent event, Emitter<Historybayar2CariState> emit) async {
	emit(const Historybayar2CariState());
  emit(state.copyWith(inv1Id: event.inv1Id));
	add(FetchHistorybayar2CariEvent());
}

Future<void> onFetchHistorybayar2Cari(
		FetchHistorybayar2CariEvent event, Emitter<Historybayar2CariState> emit) async {
	if (state.hasReachedMax) return;

	Historybayar2CariRepository repo = Historybayar2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Historybayar2CariModel> items = await repo.getHistorybayar2Cari(state.inv1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<Historybayar2CariModel> items = await repo.getHistorybayar2Cari(state.inv1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Historybayar2CariModel> historybayar2Cari = List.of(state.items)..addAll(items);

		final result = historybayar2Cari
			.whereWithIndex((e, index) =>
				historybayar2Cari.indexWhere((e2) => e2.dn1Id == e.dn1Id) ==
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