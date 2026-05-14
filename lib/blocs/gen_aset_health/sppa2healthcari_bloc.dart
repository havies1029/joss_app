import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_health/sppa2healthcari_model.dart';
import 'package:joss_app/repositories/gen_aset_health/sppa2healthcari_repository.dart';

part 'sppa2healthcari_event.dart';
part 'sppa2healthcari_state.dart';

class Sppa2healthCariBloc
		extends Bloc<Sppa2healthCariEvents, Sppa2healthCariState> {
	Sppa2healthCariBloc() : super(const Sppa2healthCariState()) {
		on<FetchSppa2healthCariEvent>(onFetchSppa2healthCari);
		on<RefreshSppa2healthCariEvent>(onRefreshSppa2healthCari);
	}

	String buildKey({
		required String sppa1Id,
		required String search,
	}) {
		return '${sppa1Id.trim()}|${search.trim().toLowerCase()}';
	}

	Future<void> onRefreshSppa2healthCari(
			RefreshSppa2healthCariEvent event,
			Emitter<Sppa2healthCariState> emit,
			) async {
		final newKey = buildKey(
			sppa1Id: event.sppa1Id,
			search: event.searchText,
		);

		emit(state.copyWith(
			status: ListStatus.initial,
			items: const <Sppa2healthCariModel>[],
			hasReachedMax: false,
			isFetching: false,
			hal: 0,
			searchText: event.searchText,
			sppa1Id: event.sppa1Id,
			queryKey: newKey,
		));

		add(FetchSppa2healthCariEvent());
	}

	Future<void> onFetchSppa2healthCari(
			FetchSppa2healthCariEvent event,
			Emitter<Sppa2healthCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;
		if (state.sppa1Id.trim().isEmpty) return;

		final repo = Sppa2healthCariRepository();
		final keyAtRequest = state.queryKey;
		final nextHal = state.hal;

		emit(state.copyWith(isFetching: true));

		try {
			final items = await repo.getSppa2healthCari(
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

			final merged = List<Sppa2healthCariModel>.of(state.items)
				..addAll(items);

			final result = merged
					.whereWithIndex(
						(e, index) =>
				merged.indexWhere(
							(e2) => e2.sppa2healthId == e.sppa2healthId,
				) ==
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