import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/notifevent/notifeventcari_model.dart';
import 'package:joss_app/repositories/notifevent/notifeventcari_repository.dart';

part 'notifeventcari_event.dart';
part 'notifeventcari_state.dart';

class NotifeventcariBloc extends Bloc<NotifeventcariEvents, NotifeventcariState> {
	NotifeventcariBloc() : super(const NotifeventcariState()) {
		on<FetchNotifeventcariEvent>(onFetchNotifeventcari);
		on<RefreshNotifeventcariEvent>(onRefreshNotifeventcari);
	}

Future<void> onRefreshNotifeventcari(
		RefreshNotifeventcariEvent event, Emitter<NotifeventcariState> emit) async {
	emit(const NotifeventcariState());
	add(FetchNotifeventcariEvent());
}

Future<void> onFetchNotifeventcari(
		FetchNotifeventcariEvent event, Emitter<NotifeventcariState> emit) async {
	if (state.hasReachedMax) return;

	NotifeventcariRepository repo = NotifeventcariRepository();
	if (state.status == ListStatus.initial) {
		List<NotifeventcariModel> items = await repo.getNotifeventcari(state.hal);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1,
			));
	}
	List<NotifeventcariModel> items = await repo.getNotifeventcari(state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<NotifeventcariModel> notifeventcari = List.of(state.items)..addAll(items);

		final result = notifeventcari
			.whereWithIndex((e, index) =>
				notifeventcari.indexWhere((e2) => e2.notifeventId == e.notifeventId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1,
			));
		}

	}
}