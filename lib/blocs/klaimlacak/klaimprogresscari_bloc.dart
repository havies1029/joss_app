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

class KlaimprogresscariBloc extends Bloc<KlaimprogresscariEvents, KlaimprogresscariState> {
	KlaimprogresscariBloc() : super(const KlaimprogresscariState()) {
		on<FetchKlaimprogresscariEvent>(onFetchKlaimprogresscari);
		on<RefreshKlaimprogresscariEvent>(onRefreshKlaimprogresscari);
	}

Future<void> onRefreshKlaimprogresscari(
		RefreshKlaimprogresscariEvent event, Emitter<KlaimprogresscariState> emit) async {
	emit(const KlaimprogresscariState());
  emit(state.copyWith(klaim1Id: event.klaim1Id));
	add(FetchKlaimprogresscariEvent());
}

Future<void> onFetchKlaimprogresscari(
		FetchKlaimprogresscariEvent event, Emitter<KlaimprogresscariState> emit) async {
	if (state.hasReachedMax) return;

	KlaimprogresscariRepository repo = KlaimprogresscariRepository();
	if (state.status == ListStatus.initial) {
    KlaimprogressCariResultModel result = await repo.getKlaimprogresscari(state.klaim1Id);
		List<KlaimprogresscariModel> items = result.listProgress;
    KlaimProgressNilaiKlaimModel? nilaiKlaim = result.nilaiKlaim;
    List<KlaimProgressJadwalBayarModel> jadwalBayar = result.jadwalBayar;
    KlaimProgressInfoModel? klaimProgressInfo = result.klaimProgressInfo;

		return emit(state.copyWith(
			items: items,
      nilaiKlaim: nilaiKlaim,
      jadwalBayar: jadwalBayar,
      klaimProgressInfo: klaimProgressInfo,
			hasReachedMax: true,
			status: ListStatus.success,
			));
	  }  
  }
}