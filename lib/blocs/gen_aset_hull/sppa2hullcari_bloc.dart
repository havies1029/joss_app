import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_hull/sppa2hullcari_model.dart';
import 'package:joss_app/repositories/gen_aset_hull/sppa2hullcari_repository.dart';

part 'sppa2hullcari_event.dart';
part 'sppa2hullcari_state.dart';

class Sppa2hullCariBloc
		extends Bloc<Sppa2hullCariEvents, Sppa2hullCariState> {
	Sppa2hullCariBloc() : super(const Sppa2hullCariState()) {
		on<FetchSppa2hullCariEvent>(onFetchSppa2hullCari);
		on<RefreshSppa2hullCariEvent>(onRefreshSppa2hullCari);
	}

	String buildKey({
		required String sppa1Id,
		required String search,
	}) {
		return '${sppa1Id.trim()}|${search.trim().toLowerCase()}';
	}

	Future<void> onRefreshSppa2hullCari(
			RefreshSppa2hullCariEvent event,
			Emitter<Sppa2hullCariState> emit,
			) async {
		final newKey = buildKey(
			sppa1Id: event.sppa1Id,
			search: event.searchText,
		);

		emit(state.copyWith(
			status: ListStatus.initial,
			items: const <Sppa2hullCariModel>[],
			hasReachedMax: false,
			isFetching: false,
			hal: 0,
			searchText: event.searchText,
			sppa1Id: event.sppa1Id,
			queryKey: newKey,
		));

		add(FetchSppa2hullCariEvent());
	}

	Future<void> onFetchSppa2hullCari(
			FetchSppa2hullCariEvent event,
			Emitter<Sppa2hullCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;
		if (state.sppa1Id.trim().isEmpty) return;

		final repo = Sppa2hullCariRepository();
		final keyAtRequest = state.queryKey;
		final nextHal = state.hal;

		emit(state.copyWith(isFetching: true));

		try {
			final items = await repo.getSppa2hullCari(
				state.sppa1Id,
				state.searchText,
				nextHal,
			);

			if (state.queryKey != keyAtRequest) return;

			if (nextHal == 0) {
				emit(state.copyWith(
					items: items,
					hasReachedMax: items.isEmpty,
					status: ListStatus.success,
					hal: 1,
					isFetching: false,
				));
				return;
			}

			if (items.isEmpty) {
				emit(state.copyWith(
					hasReachedMax: true,
					isFetching: false,
				));
				return;
			}

			final merged = List<Sppa2hullCariModel>.of(state.items)..addAll(items);

			final result = merged
					.whereWithIndex(
						(e, index) =>
				merged.indexWhere((e2) => e2.sppa2hullId == e.sppa2hullId) ==
						index,
			)
					.toList();

			emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
				isFetching: false,
			));
		} catch (_) {
			if (state.queryKey == keyAtRequest) {
				emit(state.copyWith(
					status: ListStatus.failure,
					isFetching: false,
				));
			}
		}
	}
}