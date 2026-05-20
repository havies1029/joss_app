import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/logoclient/mlogoclientcari_model.dart';
import 'package:joss_app/repositories/logoclient/mlogoclientcari_repository.dart';

part 'mlogoclientcari_event.dart';
part 'mlogoclientcari_state.dart';

class MlogoclientCariBloc extends Bloc<MlogoclientCariEvents, MlogoclientCariState> {
	MlogoclientCariBloc() : super(const MlogoclientCariState()) {
		on<FetchMlogoclientCariEvent>(onFetchMlogoclientCari);
		on<RefreshMlogoclientCariEvent>(onRefreshMlogoclientCari);
	}

Future<void> onRefreshMlogoclientCari(
		RefreshMlogoclientCariEvent event, Emitter<MlogoclientCariState> emit) async {
	emit(const MlogoclientCariState());

	add(FetchMlogoclientCariEvent());
}

Future<void> onFetchMlogoclientCari(
		FetchMlogoclientCariEvent event, Emitter<MlogoclientCariState> emit) async {
	if (state.hasReachedMax) return;

	MlogoclientCariRepository repo = MlogoclientCariRepository();
	if (state.status == ListStatus.initial) {
		List<MlogoclientCariModel> items = await repo.getMlogoclientCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<MlogoclientCariModel> items = await repo.getMlogoclientCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<MlogoclientCariModel> mlogoclientCari = List.of(state.items)..addAll(items);

		final result = mlogoclientCari
			.whereWithIndex((e, index) =>
				mlogoclientCari.indexWhere((e2) => e2.mlogoclientId == e.mlogoclientId) ==
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