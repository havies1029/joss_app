import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/layanan/mlayanan1cari_model.dart';
import 'package:joss_app/repositories/layanan/mlayanan1cari_repository.dart';

part 'mlayanan1cari_event.dart';
part 'mlayanan1cari_state.dart';

class Mlayanan1CariBloc extends Bloc<Mlayanan1CariEvents, Mlayanan1CariState> {
	Mlayanan1CariBloc() : super(const Mlayanan1CariState()) {
		on<FetchMlayanan1CariEvent>(onFetchMlayanan1Cari);
		on<RefreshMlayanan1CariEvent>(onRefreshMlayanan1Cari);
	}

	Future<void> onRefreshMlayanan1Cari(
			RefreshMlayanan1CariEvent event,
			Emitter<Mlayanan1CariState> emit,
			) async {
		final currentId = state.mlayanan1Id;

		emit(Mlayanan1CariState(mlayanan1Id: currentId));

		add(FetchMlayanan1CariEvent(mlayanan1Id: currentId));
	}

	Future<void> onFetchMlayanan1Cari(
			FetchMlayanan1CariEvent event,
			Emitter<Mlayanan1CariState> emit,
			) async {
		final repo = Mlayanan1CariRepository();

		emit(state.copyWith(
			items: const <Mlayanan1CariModel>[],
			hasReachedMax: false,
			status: ListStatus.initial,
			mlayanan1Id: event.mlayanan1Id,
		));

		try {
			final items = await repo.getMlayanan1Cari(event.mlayanan1Id);

			emit(state.copyWith(
				items: items,
				hasReachedMax: items.isEmpty,
				status: ListStatus.success,
				mlayanan1Id: event.mlayanan1Id,
			));
		} catch (_) {
			emit(state.copyWith(
				items: const <Mlayanan1CariModel>[],
				hasReachedMax: false,
				status: ListStatus.failure,
				mlayanan1Id: event.mlayanan1Id,
			));
		}
	}
}