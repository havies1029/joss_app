import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_regmv/regmv5cari_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv5cari_repository.dart';

part 'regmv5cari_event.dart';
part 'regmv5cari_state.dart';

class Regmv5CariBloc extends Bloc<Regmv5CariEvents, Regmv5CariState> {
	Regmv5CariBloc() : super(const Regmv5CariState()) {
		on<FetchRegmv5CariEvent>(onFetchRegmv5Cari);
		on<RefreshRegmv5CariEvent>(onRefreshRegmv5Cari);
	}

Future<void> onRefreshRegmv5Cari(
		RefreshRegmv5CariEvent event, Emitter<Regmv5CariState> emit) async {
	emit(Regmv5CariState(regmv1Id: event.regmv1Id));

	add(FetchRegmv5CariEvent());
}

Future<void> onFetchRegmv5Cari(
		FetchRegmv5CariEvent event, Emitter<Regmv5CariState> emit) async {
	if (state.hasReachedMax) return;

	Regmv5CariRepository repo = Regmv5CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regmv5CariModel> items = await repo.getRegmv5Cari(state.regmv1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	  }
	
	}
}