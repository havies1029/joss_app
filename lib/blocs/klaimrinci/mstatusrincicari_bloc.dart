import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/klaimrinci/mstatusrincicari_model.dart';
import 'package:joss_app/repositories/klaimrinci/mstatusrincicari_repository.dart';

part 'mstatusrincicari_event.dart';
part 'mstatusrincicari_state.dart';

class MstatusrinciCariBloc extends Bloc<MstatusrinciCariEvents, MstatusrinciCariState> {
	MstatusrinciCariBloc() : super(const MstatusrinciCariState()) {
		on<FetchMstatusrinciCariEvent>(onFetchMstatusrinciCari);
		on<RefreshMstatusrinciCariEvent>(onRefreshMstatusrinciCari);
    on<SelectedIdChanged>(onSelectedIdChanged);
    on<SearchTextChanged>(onSearchTextChanged);
	}

Future<void> onRefreshMstatusrinciCari(
		RefreshMstatusrinciCariEvent event, Emitter<MstatusrinciCariState> emit) async {
	emit(const MstatusrinciCariState());

	add(FetchMstatusrinciCariEvent());
}

Future<void> onFetchMstatusrinciCari(
		FetchMstatusrinciCariEvent event, Emitter<MstatusrinciCariState> emit) async {
	if (state.hasReachedMax) return;

	MstatusrinciCariRepository repo = MstatusrinciCariRepository();
	if (state.status == ListStatus.initial) {
		List<MstatusrinciCariModel> items = await repo.getMstatusrinciCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<MstatusrinciCariModel> items = await repo.getMstatusrinciCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<MstatusrinciCariModel> mstatusrinciCari = List.of(state.items)..addAll(items);

		final result = mstatusrinciCari
			.whereWithIndex((e, index) =>
				mstatusrinciCari.indexWhere((e2) => e2.mgroupstatusclaimId == e.mgroupstatusclaimId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}
	}

  Future<void> onSelectedIdChanged(
      SelectedIdChanged event, Emitter<MstatusrinciCariState> emit) async {
    emit(state.copyWith(selectedStatusId: event.selectedStatusId));
  }

  Future<void> onSearchTextChanged(
      SearchTextChanged event, Emitter<MstatusrinciCariState> emit) async {
    emit(state.copyWith(searchText: event.searchText));
  }
}