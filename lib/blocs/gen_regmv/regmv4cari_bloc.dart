import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_regmv/regmv4cari_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv4cari_repository.dart';

part 'regmv4cari_event.dart';
part 'regmv4cari_state.dart';

class Regmv4CariBloc extends Bloc<Regmv4CariEvents, Regmv4CariState> {
	Regmv4CariBloc() : super(const Regmv4CariState()) {
		on<FetchRegmv4CariEvent>(onFetchRegmv4Cari);
		on<RefreshRegmv4CariEvent>(onRefreshRegmv4Cari);
	}

Future<void> onRefreshRegmv4Cari(
		RefreshRegmv4CariEvent event, Emitter<Regmv4CariState> emit) async {

	emit(Regmv4CariState(regmv1Id: event.regmv1Id));

	add(FetchRegmv4CariEvent());
}

Future<void> onFetchRegmv4Cari(
		FetchRegmv4CariEvent event, Emitter<Regmv4CariState> emit) async {
	if (state.hasReachedMax) return;

	Regmv4CariRepository repo = Regmv4CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regmv4CariModel> items = await repo.getRegmv4Cari(state.regmv1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}	
}
}