import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/profile/rekanpajak_model.dart';
import 'package:joss_app/repositories/profile/rekanpajak_repository.dart';

part 'rekanpajak_event.dart';
part 'rekanpajak_state.dart';

class RekanPajakBloc extends Bloc<RekanPajakEvents, RekanPajakState> {
	final RekanPajakRepository repository;
	RekanPajakBloc({required this.repository}) : super(const RekanPajakState()) {
		on<RekanPajakUbahEvent>(onUbahRekanPajak);
		on<RekanPajakTambahEvent>(onTambahRekanPajak);
		on<RekanPajakHapusEvent>(onHapusRekanPajak);
		on<RekanPajakLihatEvent>(onLihatRekanPajak);
		on<ComboMPropinsiChangedEvent>(onComboMPropinsiChanged);
		on<ComboMKotaChangedEvent>(onComboMKotaChanged);
		on<ComboRKodeposChangedEvent>(onComboRKodeposChanged);
	}

	Future<void> onTambahRekanPajak(
		RekanPajakTambahEvent event, Emitter<RekanPajakState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.rekanPajakTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRekanPajak(
		RekanPajakUbahEvent event, Emitter<RekanPajakState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanPajakUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRekanPajak(
		RekanPajakHapusEvent event, Emitter<RekanPajakState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanPajakHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRekanPajak(
		RekanPajakLihatEvent event, Emitter<RekanPajakState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		RekanPajakModel record = await repository.rekanPajakLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMPropinsiChanged(
			ComboMPropinsiChangedEvent event, Emitter<RekanPajakState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMPropinsiModel comboMPropinsi = event.comboMPropinsi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMPropinsi: comboMPropinsi));
	}

	Future<void> onComboMKotaChanged(
			ComboMKotaChangedEvent event, Emitter<RekanPajakState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKotaModel comboMKota = event.comboMKota;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMKota: comboMKota));
	}

	Future<void> onComboRKodeposChanged(
			ComboRKodeposChangedEvent event, Emitter<RekanPajakState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKodeposModel comboRKodepos = event.comboRKodepos;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKodepos: comboRKodepos));
	}

}