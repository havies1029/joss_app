import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/gen_profile/mrekanpajakcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';

part 'mrekanpajakcrud_event.dart';
part 'mrekanpajakcrud_state.dart';

class MRekanPajakCrudBloc extends Bloc<MRekanPajakCrudEvents, MRekanPajakCrudState> {
	final MRekanPajakCrudRepository repository;
	MRekanPajakCrudBloc({required this.repository}) : super(const MRekanPajakCrudState()) {
		on<MRekanPajakCrudUbahEvent>(onUbahMRekanPajakCrud);
		on<MRekanPajakCrudLihatEvent>(onLihatMRekanPajakCrud);
		on<ComboMPropinsiChangedEvent>(onComboMPropinsiChanged);
		on<ComboMKotaChangedEvent>(onComboMKotaChanged);
		on<ComboRKodeposChangedEvent>(onComboRKodeposChanged);
	}


	Future<void> onUbahMRekanPajakCrud(
		MRekanPajakCrudUbahEvent event, Emitter<MRekanPajakCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.mRekanPajakCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure, record: event.record));
	}

	Future<void> onLihatMRekanPajakCrud(
		MRekanPajakCrudLihatEvent event, Emitter<MRekanPajakCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		MRekanPajakCrudModel record = await repository.mRekanPajakCrudLihat();
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMPropinsiChanged(
			ComboMPropinsiChangedEvent event, Emitter<MRekanPajakCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMPropinsiModel comboMPropinsi = event.comboMPropinsi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMPropinsi: comboMPropinsi));
	}

	Future<void> onComboMKotaChanged(
			ComboMKotaChangedEvent event, Emitter<MRekanPajakCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKotaModel comboMKota = event.comboMKota;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMKota: comboMKota));
	}

	Future<void> onComboRKodeposChanged(
			ComboRKodeposChangedEvent event, Emitter<MRekanPajakCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKodeposModel comboRKodepos = event.comboRKodepos;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKodepos: comboRKodepos));
	}

}