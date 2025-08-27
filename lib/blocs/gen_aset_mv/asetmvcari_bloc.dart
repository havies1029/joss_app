import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';
import 'package:joss_app/repositories/gen_aset_mv/asetmvcari_repository.dart';

part 'asetmvcari_event.dart';
part 'asetmvcari_state.dart';

class AsetMvCariBloc extends Bloc<AsetMvCariEvents, AsetMvCariState> {
	AsetMvCariBloc() : super(const AsetMvCariState()) {
		on<FetchAsetMvCariEvent>(onFetchAsetMvCari);
		on<RefreshAsetMvCariEvent>(onRefreshAsetMvCari);
	}

Future<void> onRefreshAsetMvCari(
		RefreshAsetMvCariEvent event, Emitter<AsetMvCariState> emit) async {
	emit(const AsetMvCariState());

  emit(state.copyWith(
    status: ListStatus.initial,
    items: const <AsetMvCariModel>[],
    hasReachedMax: false,
    hal: 0,
    searchText: event.searchText,
    statusId: event.statusId,
    ));

	add(FetchAsetMvCariEvent());
}

Future<void> onFetchAsetMvCari(
		FetchAsetMvCariEvent event, Emitter<AsetMvCariState> emit) async {
	if (state.hasReachedMax) return;

	AsetMvCariRepository repo = AsetMvCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsetMvCariModel> items = await repo.getAsetMvCari(state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<AsetMvCariModel> items = await repo.getAsetMvCari(state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsetMvCariModel> asetMvCari = List.of(state.items)..addAll(items);

		final result = asetMvCari
			.whereWithIndex((e, index) =>
				asetMvCari.indexWhere((e2) => e2.asetMvId == e.asetMvId) ==
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