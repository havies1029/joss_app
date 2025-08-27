import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_promo/promo2cari_model.dart';
import 'package:joss_app/repositories/gen_promo/promo2cari_repository.dart';

part 'promo2cari_event.dart';
part 'promo2cari_state.dart';

class Promo2CariBloc extends Bloc<Promo2CariEvents, Promo2CariState> {
	Promo2CariBloc() : super(const Promo2CariState()) {
		on<FetchPromo2CariEvent>(onFetchPromo2Cari);
		on<RefreshPromo2CariEvent>(onRefreshPromo2Cari);
	}

Future<void> onRefreshPromo2Cari(
		RefreshPromo2CariEvent event, Emitter<Promo2CariState> emit) async {
	emit(const Promo2CariState());

  emit(state.copyWith(promo1Id: event.promo1Id));
	add(FetchPromo2CariEvent());
}

Future<void> onFetchPromo2Cari(
		FetchPromo2CariEvent event, Emitter<Promo2CariState> emit) async {
	if (state.hasReachedMax) return;

	Promo2CariRepository repo = Promo2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Promo2CariModel> items = await repo.getPromo2Cari(state.promo1Id, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Promo2CariModel> items = await repo.getPromo2Cari(state.promo1Id, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Promo2CariModel> promo2Cari = List.of(state.items)..addAll(items);

		final result = promo2Cari
			.whereWithIndex((e, index) =>
				promo2Cari.indexWhere((e2) => e2.promo2Id == e.promo2Id) ==
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