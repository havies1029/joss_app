import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_regmv/regmv7cari_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv7cari_repository.dart';

part 'regmv7cari_event.dart';
part 'regmv7cari_state.dart';

class Regmv7CariBloc extends Bloc<Regmv7CariEvents, Regmv7CariState> {
	Regmv7CariBloc() : super(const Regmv7CariState()) {
		on<FetchRegmv7CariEvent>(onFetchRegmv7Cari);
		on<RefreshRegmv7CariEvent>(onRefreshRegmv7Cari);
    on<Regmv7CariResetEvent>((event, emit) => emit(const Regmv7CariState.reset()));
	}

	Future<void> onRefreshRegmv7Cari(
			RefreshRegmv7CariEvent event,
			Emitter<Regmv7CariState> emit,
			) async {

		emit(Regmv7CariState(regmv1Id: event.regmv1Id));
		add(FetchRegmv7CariEvent());
	}


Future<void> onFetchRegmv7Cari(
		FetchRegmv7CariEvent event, Emitter<Regmv7CariState> emit) async {
	if (state.hasReachedMax) return;

	Regmv7CariRepository repo = Regmv7CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regmv7CariModel> items = await repo.getRegmv7Cari(state.regmv1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}	
}
}