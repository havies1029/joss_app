import 'package:joss_app/models/klaimrasio/klaimrasiocari_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/klaimrasio/klaimrasiocobcari_repository.dart';

part 'klaimrasiocobcari_event.dart';
part 'klaimrasiocobcari_state.dart';

class KlaimrasiocobCariBloc extends Bloc<KlaimrasiocobCariEvents, KlaimrasiocobCariState> {
	KlaimrasiocobCariBloc() : super(KlaimrasiocobCariState()) {
		on<FetchKlaimrasiocobCariEvent>(onFetchKlaimrasiocobCari);
		on<RefreshKlaimrasiocobCariEvent>(onRefreshKlaimrasiocobCari);
	}

Future<void> onRefreshKlaimrasiocobCari(
		RefreshKlaimrasiocobCariEvent event, Emitter<KlaimrasiocobCariState> emit) async {
	emit(KlaimrasiocobCariState());
  emit(state.copyWith(searchText: event.searchText));
	add(FetchKlaimrasiocobCariEvent());
}

Future<void> onFetchKlaimrasiocobCari(
		FetchKlaimrasiocobCariEvent event, Emitter<KlaimrasiocobCariState> emit) async {
	if (state.hasReachedMax) return;

	KlaimrasiocobCariRepository repo = KlaimrasiocobCariRepository();
	if (state.status == ListStatus.initial) {
		KlaimrasiocariModel klaimRasio = await repo.getKlaimrasiocobCari(state.searchText);
		return emit(state.copyWith(
			klaimRasio: klaimRasio,
			hasReachedMax: false,
			status: ListStatus.success));
	  }	
	}

}