import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';
import 'package:joss_app/repositories/payment/historybayarcari_repository.dart';

part 'historybayarcari_event.dart';
part 'historybayarcari_state.dart';

class HistorybayarCariBloc extends Bloc<HistorybayarCariEvents, HistorybayarCariState> {
	HistorybayarCariBloc() : super(const HistorybayarCariState()) {
		on<FetchHistorybayarCariEvent>(onFetchHistorybayarCari);
		on<RefreshHistorybayarCariEvent>(onRefreshHistorybayarCari);
	}

Future<void> onRefreshHistorybayarCari(
		RefreshHistorybayarCariEvent event, Emitter<HistorybayarCariState> emit) async {
	emit(const HistorybayarCariState());

	add(FetchHistorybayarCariEvent());
}

Future<void> onFetchHistorybayarCari(
		FetchHistorybayarCariEvent event, Emitter<HistorybayarCariState> emit) async {
	if (state.hasReachedMax) return;

	HistorybayarCariRepository repo = HistorybayarCariRepository();
	if (state.status == ListStatus.initial) {
		List<HistorybayarCariModel> items = await repo.getHistorybayarCari(state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<HistorybayarCariModel> items = await repo.getHistorybayarCari(state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<HistorybayarCariModel> historybayarCari = List.of(state.items)..addAll(items);

		final result = historybayarCari
			.whereWithIndex((e, index) =>
				historybayarCari.indexWhere((e2) => e2.inv1Id == e.inv1Id) ==
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