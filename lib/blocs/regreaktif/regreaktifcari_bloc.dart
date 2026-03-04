import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regreaktif/regreaktifcari_model.dart';
import 'package:joss_app/repositories/regreaktif/regreaktifcari_repository.dart';

part 'regreaktifcari_event.dart';
part 'regreaktifcari_state.dart';

class RegreaktifCariBloc extends Bloc<RegreaktifCariEvents, RegreaktifCariState> {
	RegreaktifCariBloc() : super(const RegreaktifCariState()) {
		on<FetchRegreaktifCariEvent>(onFetchRegreaktifCari);
		on<RefreshRegreaktifCariEvent>(onRefreshRegreaktifCari);
	}

Future<void> onRefreshRegreaktifCari(
		RefreshRegreaktifCariEvent event, Emitter<RegreaktifCariState> emit) async {
	emit(const RegreaktifCariState());

  emit(state.copyWith(searchText: event.searchText));

	add(FetchRegreaktifCariEvent());
}

Future<void> onFetchRegreaktifCari(
		FetchRegreaktifCariEvent event, Emitter<RegreaktifCariState> emit) async {
	if (state.hasReachedMax) return;

	RegreaktifCariRepository repo = RegreaktifCariRepository();
	if (state.status == ListStatus.initial) {
		List<RegreaktifCariModel> items = await repo.getRegreaktifCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<RegreaktifCariModel> items = await repo.getRegreaktifCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<RegreaktifCariModel> regreaktifCari = List.of(state.items)..addAll(items);

		final result = regreaktifCari
			.whereWithIndex((e, index) =>
				regreaktifCari.indexWhere((e2) => e2.regreaktif1Id == e.regreaktif1Id) ==
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