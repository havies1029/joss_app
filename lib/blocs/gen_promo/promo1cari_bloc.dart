import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_promo/promo1cari_model.dart';
import 'package:joss_app/repositories/gen_promo/promo1cari_repository.dart';

part 'promo1cari_event.dart';
part 'promo1cari_state.dart';

class Promo1CariBloc extends Bloc<Promo1CariEvents, Promo1CariState> {
	Promo1CariBloc() : super(const Promo1CariState()) {
		on<FetchPromo1CariEvent>(onFetchPromo1Cari);
		on<RefreshPromo1CariEvent>(onRefreshPromo1Cari);
	}

Future<void> onRefreshPromo1Cari(
		RefreshPromo1CariEvent event, Emitter<Promo1CariState> emit) async {
	emit(const Promo1CariState());

	add(FetchPromo1CariEvent());
}

Future<void> onFetchPromo1Cari(
		FetchPromo1CariEvent event, Emitter<Promo1CariState> emit) async {
	if (state.hasReachedMax) return;

	Promo1CariRepository repo = Promo1CariRepository();
	if (state.status == ListStatus.initial) {
		List<Promo1CariModel> items = await repo.getPromo1Cari(0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Promo1CariModel> items = await repo.getPromo1Cari(state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Promo1CariModel> promo1Cari = List.of(state.items)..addAll(items);

		final result = promo1Cari
			.whereWithIndex((e, index) =>
				promo1Cari.indexWhere((e2) => e2.promo1Id == e.promo1Id) ==
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