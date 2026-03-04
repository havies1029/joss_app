import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/regother/regother3cari_model.dart';
import 'package:joss_app/repositories/regother/regother3cari_repository.dart';

part 'regother3cari_event.dart';
part 'regother3cari_state.dart';

class Regother3cariBloc extends Bloc<Regother3cariEvents, Regother3cariState> {
	Regother3cariBloc() : super(const Regother3cariState()) {
		on<FetchRegother3cariEvent>(onFetchRegother3cari);
		on<RefreshRegother3cariEvent>(onRefreshRegother3cari);
	}

Future<void> onRefreshRegother3cari(
		RefreshRegother3cariEvent event, Emitter<Regother3cariState> emit) async {
	emit(const Regother3cariState());
  emit(state.copyWith(regother1Id: event.regother1Id));
	add(FetchRegother3cariEvent());
}

Future<void> onFetchRegother3cari(
		FetchRegother3cariEvent event, Emitter<Regother3cariState> emit) async {
	if (state.hasReachedMax) return;

	Regother3cariRepository repo = Regother3cariRepository();
	if (state.status == ListStatus.initial) {
		List<Regother3cariModel> items = await repo.getRegother3cari(state.regother1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: true,
			status: ListStatus.success,
			));
	}
	
  }
}