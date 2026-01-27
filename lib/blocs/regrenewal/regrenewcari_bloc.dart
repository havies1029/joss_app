import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regrenewal/regrenewcari_model.dart';
import 'package:joss_app/repositories/regrenewal/regrenewcari_repository.dart';

part 'regrenewcari_event.dart';
part 'regrenewcari_state.dart';

class RegrenewCariBloc extends Bloc<RegrenewCariEvents, RegrenewCariState> {
	RegrenewCariBloc() : super(const RegrenewCariState()) {
		on<FetchRegrenewCariEvent>(onFetchRegrenewCari);
		on<RefreshRegrenewCariEvent>(onRefreshRegrenewCari);
	}

Future<void> onRefreshRegrenewCari(
		RefreshRegrenewCariEvent event, Emitter<RegrenewCariState> emit) async {
	emit(const RegrenewCariState());
  emit(state.copyWith(searchText: event.searchText));
	add(FetchRegrenewCariEvent());
}

Future<void> onFetchRegrenewCari(
		FetchRegrenewCariEvent event, Emitter<RegrenewCariState> emit) async {
	if (state.hasReachedMax) return;

	RegrenewCariRepository repo = RegrenewCariRepository();
	if (state.status == ListStatus.initial) {
		List<RegrenewCariModel> items = await repo.getRegrenewCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<RegrenewCariModel> items = await repo.getRegrenewCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<RegrenewCariModel> regrenewCari = List.of(state.items)..addAll(items);

		final result = regrenewCari
			.whereWithIndex((e, index) =>
				regrenewCari.indexWhere((e2) => e2.regrenew1Id == e.regrenew1Id) ==
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