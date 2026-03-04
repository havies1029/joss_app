import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/notiflog/logtrscari_model.dart';
import 'package:joss_app/repositories/notiflog/logtrscari_repository.dart';

part 'logtrscari_event.dart';
part 'logtrscari_state.dart';

class LogtrscariBloc extends Bloc<LogtrscariEvents, LogtrscariState> {
	LogtrscariBloc() : super(const LogtrscariState()) {
		on<FetchLogtrscariEvent>(onFetchLogtrscari);
		on<RefreshLogtrscariEvent>(onRefreshLogtrscari);
	}

	Future<void> onRefreshLogtrscari(
			RefreshLogtrscariEvent event,
			Emitter<LogtrscariState> emit,
			) async {
		emit(LogtrscariState(groupLogId: event.groupLogId));
		add(FetchLogtrscariEvent());
	}

	Future<void> onFetchLogtrscari(
			FetchLogtrscariEvent event,
			Emitter<LogtrscariState> emit,
			) async {
		if (state.hasReachedMax || state.isLoadingMore) return;

		final repo = LogtrscariRepository();

		try {
			if (state.status == ListStatus.initial) {
				final items = await repo.getLogtrscari(state.groupLogId, state.hal);

				final reachedMax = items.isEmpty;

				emit(state.copyWith(
					items: items,
					hasReachedMax: reachedMax,
					status: ListStatus.success,
					hal: reachedMax ? state.hal : state.hal + 1,
					isLoadingMore: false,
				));
				return;
			}

			emit(state.copyWith(isLoadingMore: true));

			final items = await repo.getLogtrscari(state.groupLogId, state.hal);

			if (items.isEmpty) {
				emit(state.copyWith(
					hasReachedMax: true,
					isLoadingMore: false,
				));
				return;
			}

			final merged = List<LogtrscariModel>.of(state.items)..addAll(items);

			final result = merged
					.whereWithIndex((e, index) =>
			merged.indexWhere((e2) => e2.logId == e.logId) == index)
					.toList();

			emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
				isLoadingMore: false,
			));
		} catch (e) {
			emit(state.copyWith(
				status: ListStatus.failure,
				isLoadingMore: false,
			));
		}
	}
}