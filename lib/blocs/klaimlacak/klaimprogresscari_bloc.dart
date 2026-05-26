import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';
import 'package:joss_app/repositories/klaimlacak/klaimprogresscari_repository.dart';

part 'klaimprogresscari_event.dart';
part 'klaimprogresscari_state.dart';

class KlaimprogresscariBloc
		extends Bloc<KlaimprogresscariEvents, KlaimprogresscariState> {
	KlaimprogresscariBloc() : super(const KlaimprogresscariState()) {
		on<FetchKlaimprogresscariEvent>(onFetchKlaimprogresscari);
		on<RefreshKlaimprogresscariEvent>(onRefreshKlaimprogresscari);
	}

	Future<void> onRefreshKlaimprogresscari(
			RefreshKlaimprogresscariEvent event,
			Emitter<KlaimprogresscariState> emit,
			) async {
		// reset total state lama, tapi klaim1Id tetap masuk
		emit(
			KlaimprogresscariState(
				klaim1Id: event.klaim1Id,
			),
		);

		add(FetchKlaimprogresscariEvent());
	}

	Future<void> onFetchKlaimprogresscari(
			FetchKlaimprogresscariEvent event,
			Emitter<KlaimprogresscariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.klaim1Id.trim().isEmpty) return;

		emit(state.copyWith(status: ListStatus.loadingMore));

		try {
			final repo = KlaimprogresscariRepository();
			final result = await repo.getKlaimprogresscari(state.klaim1Id);

			emit(
				state.copyWith(
					items: result?.listProgress ?? const [],
					nilaiKlaim: result?.nilaiKlaim,
					jadwalBayar: result?.jadwalBayar ?? const [],
					klaimProgressInfo: result?.klaimProgressInfo,
					hasReachedMax: true,
					status: ListStatus.success,
				),
			);
		} catch (e) {
			emit(state.copyWith(status: ListStatus.failure));
		}
	}
}