import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';
import 'package:joss_app/repositories/asetothers/sppa2otherscari_repository.dart';

part 'sppa2otherscari_event.dart';
part 'sppa2otherscari_state.dart';

class Sppa2othersCariBloc extends Bloc<Sppa2othersCariEvents, Sppa2othersCariState> {
	Sppa2othersCariBloc() : super(const Sppa2othersCariState()) {
		on<FetchSppa2othersCariEvent>(onFetchSppa2othersCari);
		on<RefreshSppa2othersCariEvent>(onRefreshSppa2othersCari);
	}

Future<void> onRefreshSppa2othersCari(
		RefreshSppa2othersCariEvent event, Emitter<Sppa2othersCariState> emit) async {
	emit(const Sppa2othersCariState());

	add(FetchSppa2othersCariEvent());
}

Future<void> onFetchSppa2othersCari(
		FetchSppa2othersCariEvent event, Emitter<Sppa2othersCariState> emit) async {
	if (state.hasReachedMax) return;

	Sppa2othersCariRepository repo = Sppa2othersCariRepository();
	if (state.status == ListStatus.initial) {
		List<Sppa2othersCariModel> items = await repo.getSppa2othersCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<Sppa2othersCariModel> items = await repo.getSppa2othersCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<Sppa2othersCariModel> sppa2othersCari = List.of(state.items)..addAll(items);

		final result = sppa2othersCari
			.whereWithIndex((e, index) =>
				sppa2othersCari.indexWhere((e2) => e2.sppa2othersId == e.sppa2othersId) ==
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