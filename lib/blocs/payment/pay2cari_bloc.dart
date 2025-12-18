import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/pay2cari_model.dart';
import 'package:joss_app/repositories/payment/pay2cari_repository.dart';

part 'pay2cari_event.dart';
part 'pay2cari_state.dart';

class Pay2CariBloc extends Bloc<Pay2CariEvents, Pay2CariState> {
	Pay2CariBloc() : super(const Pay2CariState()) {
		on<FetchPay2CariEvent>(onFetchPay2Cari);
		on<RefreshPay2CariEvent>(onRefreshPay2Cari);
	}

Future<void> onRefreshPay2Cari(
		RefreshPay2CariEvent event, Emitter<Pay2CariState> emit) async {
	emit(const Pay2CariState());

  emit(state.copyWith(ar1Id: event.ar1Id));

	add(FetchPay2CariEvent());
}

Future<void> onFetchPay2Cari(
		FetchPay2CariEvent event, Emitter<Pay2CariState> emit) async {
	if (state.hasReachedMax) return;

	Pay2CariRepository repo = Pay2CariRepository();
	if (state.status == ListStatus.initial) {
		List<Pay2CariModel> items = await repo.getPay2Cari(state.ar1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Pay2CariModel> items = await repo.getPay2Cari(state.ar1Id);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Pay2CariModel> pay2Cari = List.of(state.items)..addAll(items);

		final result = pay2Cari
			.whereWithIndex((e, index) =>
				pay2Cari.indexWhere((e2) => e2.ar2Id == e.ar2Id) ==
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