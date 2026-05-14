import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';
import 'package:joss_app/repositories/asetothers/sppa2otherscari_repository.dart';

part 'sppa2otherscari_event.dart';
part 'sppa2otherscari_state.dart';

class Sppa2othersCariBloc
		extends Bloc<Sppa2othersCariEvents, Sppa2othersCariState> {
	Sppa2othersCariBloc() : super(const Sppa2othersCariState()) {
		on<FetchSppa2othersCariEvent>(onFetchSppa2othersCari);
		on<RefreshSppa2othersCariEvent>(onRefreshSppa2othersCari);
	}

	String buildKey({
		required String sppa1Id,
		required String search,
	}) {
		return '${sppa1Id.trim()}|${search.trim().toLowerCase()}';
	}

	Future<void> onRefreshSppa2othersCari(
			RefreshSppa2othersCariEvent event,
			Emitter<Sppa2othersCariState> emit,
			) async {
		final newKey = buildKey(
			sppa1Id: event.sppa1Id,
			search: event.searchText,
		);

		emit(state.copyWith(
			status: ListStatus.initial,
			items: const <Sppa2othersCariModel>[],
			hasReachedMax: false,
			isFetching: false,
			hal: 0,
			searchText: event.searchText,
			sppa1Id: event.sppa1Id,
			queryKey: newKey,
		));

		add(FetchSppa2othersCariEvent());
	}

	Future<void> onFetchSppa2othersCari(
			FetchSppa2othersCariEvent event,
			Emitter<Sppa2othersCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;
		if (state.sppa1Id.trim().isEmpty) return;

		final repo = Sppa2othersCariRepository();
		final keyAtRequest = state.queryKey;
		final nextHal = state.hal;

		emit(state.copyWith(isFetching: true));

		try {
			final items = await repo.getSppa2othersCari(
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

			final merged = List<Sppa2othersCariModel>.of(state.items)
				..addAll(items);

			final result = merged
					.whereWithIndex(
						(e, index) =>
				merged.indexWhere(
							(e2) => e2.sppa2othersId == e.sppa2othersId,
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