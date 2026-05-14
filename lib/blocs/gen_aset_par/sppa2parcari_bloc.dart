import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_par/sppa2parcari_model.dart';
import 'package:joss_app/repositories/gen_aset_par/sppa2parcari_repository.dart';

part 'sppa2parcari_event.dart';
part 'sppa2parcari_state.dart';

class Sppa2parCariBloc extends Bloc<Sppa2parCariEvents, Sppa2parCariState> {
	Sppa2parCariBloc() : super(const Sppa2parCariState()) {
		on<FetchSppa2parCariEvent>(onFetchSppa2parCari);
		on<RefreshSppa2parCariEvent>(onRefreshSppa2parCari);
	}

	String buildKey({
		required String sppa1Id,
		required String search,
	}) {
		return '${sppa1Id.trim()}|${search.trim().toLowerCase()}';
	}

	Future<void> onRefreshSppa2parCari(
			RefreshSppa2parCariEvent event,
			Emitter<Sppa2parCariState> emit,
			) async {
		final newKey = buildKey(
			sppa1Id: event.sppa1Id,
			search: event.searchText,
		);

		emit(state.copyWith(
			status: ListStatus.initial,
			items: const <Sppa2parCariModel>[],
			hasReachedMax: false,
			isFetching: false,
			hal: 0,
			searchText: event.searchText,
			sppa1Id: event.sppa1Id,
			queryKey: newKey,
		));

		add(FetchSppa2parCariEvent());
	}

	Future<void> onFetchSppa2parCari(
			FetchSppa2parCariEvent event,
			Emitter<Sppa2parCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;
		if (state.sppa1Id.trim().isEmpty) return;

		final repo = Sppa2parCariRepository();
		final keyAtRequest = state.queryKey;
		final nextHal = state.hal;

		emit(state.copyWith(isFetching: true));

		try {
			final items = await repo.getSppa2parCari(
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

			final merged = List<Sppa2parCariModel>.of(state.items)..addAll(items);

			final result = merged
					.whereWithIndex(
						(e, index) =>
				merged.indexWhere((e2) => e2.sppa2parId == e.sppa2parId) ==
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