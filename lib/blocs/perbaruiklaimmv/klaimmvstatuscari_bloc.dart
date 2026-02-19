import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscari_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvstatuscari_repository.dart';

part 'klaimmvstatuscari_event.dart';
part 'klaimmvstatuscari_state.dart';

class KlaimmvstatuscariBloc extends Bloc<KlaimmvstatuscariEvents, KlaimmvstatuscariState> {
	KlaimmvstatuscariBloc() : super(const KlaimmvstatuscariState()) {
		on<FetchKlaimmvstatuscariEvent>(onFetchKlaimmvstatuscari);
		on<RefreshKlaimmvstatuscariEvent>(onRefreshKlaimmvstatuscari);
	}

Future<void> onRefreshKlaimmvstatuscari(
		RefreshKlaimmvstatuscariEvent event, Emitter<KlaimmvstatuscariState> emit) async {
	emit(KlaimmvstatuscariState(klaim1Id: event.klaim1Id));
  
	add(FetchKlaimmvstatuscariEvent());
}

Future<void> onFetchKlaimmvstatuscari(
		FetchKlaimmvstatuscariEvent event, Emitter<KlaimmvstatuscariState> emit) async {
	if (state.hasReachedMax) return;

	KlaimmvstatuscariRepository repo = KlaimmvstatuscariRepository();
	if (state.status == ListStatus.initial) {
		List<KlaimmvstatuscariModel> items = await repo.getKlaimmvstatuscari(state.klaim1Id);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: true,
			status: ListStatus.success,
			));
  }
	}
}