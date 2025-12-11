import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/regpar/regpar6cari_model.dart';
import 'package:joss_app/repositories/regpar/regpar6cari_repository.dart';

part 'regpar6cari_event.dart';
part 'regpar6cari_state.dart';

class Regpar6CariBloc extends Bloc<Regpar6CariEvents, Regpar6CariState> {
	Regpar6CariBloc() : super(const Regpar6CariState()) {
		on<FetchRegpar6CariEvent>(onFetchRegpar6Cari);
		on<RefreshRegpar6CariEvent>(onRefreshRegpar6Cari);
    on<Regpar6CariResetEvent>((event, emit) => emit(const Regpar6CariState.reset()));
	}

Future<void> onRefreshRegpar6Cari(
		RefreshRegpar6CariEvent event, Emitter<Regpar6CariState> emit) async {

  emit(state.copyWith(regpar1Id: event.regpar1Id));

	add(FetchRegpar6CariEvent());
}

Future<void> onFetchRegpar6Cari(
		FetchRegpar6CariEvent event, Emitter<Regpar6CariState> emit) async {
	if (state.hasReachedMax) return;

	Regpar6CariRepository repo = Regpar6CariRepository();
	if (state.status == ListStatus.initial) {
		List<Regpar6CariModel> items = await repo.getRegpar6Cari(state.regpar1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	  }
  }
	
}