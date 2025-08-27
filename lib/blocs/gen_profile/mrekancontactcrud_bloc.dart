import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';

part 'mrekancontactcrud_event.dart';
part 'mrekancontactcrud_state.dart';

class MRekanContactCrudBloc extends Bloc<MRekanContactCrudEvents, MRekanContactCrudState> {
	final MRekanContactCrudRepository repository;
	MRekanContactCrudBloc({required this.repository}) : super(const MRekanContactCrudState()) {
		on<MRekanContactCrudUbahEvent>(onUbahMRekanContactCrud);
		on<MRekanContactCrudLihatEvent>(onLihatMRekanContactCrud);
		on<ComboMPropinsiChangedEvent>(onComboMPropinsiChanged);
		on<ComboMKotaChangedEvent>(onComboMKotaChanged);
		on<ComboRKodeposChangedEvent>(onComboRKodeposChanged);
	}
	
	Future<void> onUbahMRekanContactCrud(
		MRekanContactCrudUbahEvent event, Emitter<MRekanContactCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.mRekanContactCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure, record: event.record));
	}

	Future<void> onLihatMRekanContactCrud(
			MRekanContactCrudLihatEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));

		MRekanContactCrudModel record = await repository.mRekanContactCrudLihat();

		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			record: record,
			comboMPropinsi: record.comboMPropinsi,
			comboMKota: record.comboMKota,
			comboRKodepos: record.comboRKodepos,
		));
	}

	Future<void> onComboMPropinsiChanged(
			ComboMPropinsiChangedEvent event, Emitter<MRekanContactCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMPropinsiModel comboMPropinsi = event.comboMPropinsi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMPropinsi: comboMPropinsi));
	}

	Future<void> onComboMKotaChanged(
			ComboMKotaChangedEvent event, Emitter<MRekanContactCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKotaModel comboMKota = event.comboMKota;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMKota: comboMKota));
	}

	Future<void> onComboRKodeposChanged(
			ComboRKodeposChangedEvent event, Emitter<MRekanContactCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKodeposModel comboRKodepos = event.comboRKodepos;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKodepos: comboRKodepos));
	}

}