import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/notiflog/logtrscari_model.dart';
import 'package:joss_app/repositories/notiflog/logtrscari_repository.dart';

part 'logtrscaritopx_event.dart';
part 'logtrscaritopx_state.dart';

class LogtrscaritopxBloc extends Bloc<LogtrscaritopxEvents, LogtrscaritopxState> {
	LogtrscaritopxBloc() : super(const LogtrscaritopxState()) {
		on<FetchLogtrscaritopxEvent>(onFetchLogtrscaritopx);
		on<RefreshLogtrscaritopxEvent>(onRefreshLogtrscaritopx);
	}

Future<void> onRefreshLogtrscaritopx(
		RefreshLogtrscaritopxEvent event, Emitter<LogtrscaritopxState> emit) async {
	emit(const LogtrscaritopxState());
	add(FetchLogtrscaritopxEvent());
}

Future<void> onFetchLogtrscaritopx(
		FetchLogtrscaritopxEvent event, Emitter<LogtrscaritopxState> emit) async {
	if (state.hasReachedMax) return;

	LogtrscariRepository repo = LogtrscariRepository();
	if (state.status == ListStatus.initial) {
		List<LogtrscariModel> items = await repo.getLogtrscaritopx();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: true,
			status: ListStatus.success,
			));
    }
  }
}