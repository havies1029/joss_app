import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';
import 'package:joss_app/repositories/gen_endors/endors2cari_repository.dart';

part 'endors2cari_event.dart';
part 'endors2cari_state.dart';

class Endors2CariBloc extends Bloc<Endors2CariEvents, Endors2CariState> {
	Endors2CariBloc() : super(const Endors2CariState()) {
		on<FetchEndors2CariEvent>(onFetchEndors2Cari);
		on<RefreshEndors2CariEvent>(onRefreshEndors2Cari);
	}

	Future<void> onRefreshEndors2Cari(
			RefreshEndors2CariEvent event, Emitter<Endors2CariState> emit) async {
		emit(const Endors2CariState());

		emit(state.copyWith(sppa1Id: event.sppa1Id));

		add(FetchEndors2CariEvent());
	}

	Future<void> onFetchEndors2Cari(
			FetchEndors2CariEvent event, Emitter<Endors2CariState> emit) async {
		if (state.hasReachedMax) return;

		Endors2CariRepository repo = Endors2CariRepository();
		if (state.status == ListStatus.initial) {
			List<Endors2CariModel> items = await repo.getEndors2Cari(state.sppa1Id);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
			));
		}

	}
}