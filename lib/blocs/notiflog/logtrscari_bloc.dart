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
		RefreshLogtrscariEvent event, Emitter<LogtrscariState> emit) async {
	emit(const LogtrscariState());
  emit(state.copyWith(groupLogId: event.groupLogId));
	add(FetchLogtrscariEvent());
}

Future<void> onFetchLogtrscari(
		FetchLogtrscariEvent event, Emitter<LogtrscariState> emit) async {
	if (state.hasReachedMax) return;

	LogtrscariRepository repo = LogtrscariRepository();
	if (state.status == ListStatus.initial) {
		List<LogtrscariModel> items = await repo.getLogtrscari(state.groupLogId, state.hal);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1,
			));
	}
	List<LogtrscariModel> items = await repo.getLogtrscari(state.groupLogId, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<LogtrscariModel> logtrscari = List.of(state.items)..addAll(items);

		final result = logtrscari
			.whereWithIndex((e, index) =>
				logtrscari.indexWhere((e2) => e2.logId == e.logId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1,
			));
		}

	}
}