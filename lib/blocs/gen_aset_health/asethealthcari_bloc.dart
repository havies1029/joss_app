import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';
import 'package:joss_app/repositories/gen_aset_health/asethealthcari_repository.dart';

part 'asethealthcari_event.dart';
part 'asethealthcari_state.dart';

class AsetHealthCariBloc extends Bloc<AsetHealthCariEvents, AsetHealthCariState> {
	AsetHealthCariBloc() : super(const AsetHealthCariState()) {
		on<FetchAsetHealthCariEvent>(onFetchAsetHealthCari);
		on<RefreshAsetHealthCariEvent>(onRefreshAsetHealthCari);
	}

Future<void> onRefreshAsetHealthCari(
		RefreshAsetHealthCariEvent event, Emitter<AsetHealthCariState> emit) async {
	emit(const AsetHealthCariState());
  
  emit(state.copyWith(statusId: event.statusId, searchText: event.searchText));

	add(FetchAsetHealthCariEvent());
}

Future<void> onFetchAsetHealthCari(
		FetchAsetHealthCariEvent event, Emitter<AsetHealthCariState> emit) async {
	if (state.hasReachedMax) return;

	AsetHealthCariRepository repo = AsetHealthCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsetHealthCariModel> items = await repo.getAsetHealthCari(state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<AsetHealthCariModel> items = await repo.getAsetHealthCari(state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsetHealthCariModel> asetHealthCari = List.of(state.items)..addAll(items);

		final result = asetHealthCari
			.whereWithIndex((e, index) =>
				asetHealthCari.indexWhere((e2) => e2.asethealthId == e.asethealthId) ==
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