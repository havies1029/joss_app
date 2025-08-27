import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/gen_sppapar/sppaparcrud_model.dart';
import 'package:joss_app/repositories/gen_sppapar/sppaparcrud_repository.dart';

part 'sppaparcrud_event.dart';
part 'sppaparcrud_state.dart';

class SppaparCrudBloc extends Bloc<SppaparCrudEvents, SppaparCrudState> {
	final SppaparCrudRepository repository;
	SppaparCrudBloc({required this.repository}) : super(const SppaparCrudState()) {
		on<SppaparCrudUbahEvent>(onUbahSppaparCrud);
		on<SppaparCrudTambahEvent>(onTambahSppaparCrud);
		on<SppaparCrudHapusEvent>(onHapusSppaparCrud);
		on<SppaparCrudLihatEvent>(onLihatSppaparCrud);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
		on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
		on<ComboMBiindemnityOjkChangedEvent>(onComboMBiindemnityOjkChanged);
		on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMTarifojkBanjirParChangedEvent>(onComboMTarifojkBanjirParChanged);
		on<ComboRKodeposChangedEvent>(onComboRKodeposChanged);
	}

	Future<void> onTambahSppaparCrud(
		SppaparCrudTambahEvent event, Emitter<SppaparCrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.sppaparCrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahSppaparCrud(
		SppaparCrudUbahEvent event, Emitter<SppaparCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.sppaparCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusSppaparCrud(
		SppaparCrudHapusEvent event, Emitter<SppaparCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.sppaparCrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatSppaparCrud(
		SppaparCrudLihatEvent event, Emitter<SppaparCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		SppaparCrudModel record = await repository.sppaparCrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record,      
      comboROkupasi: record.comboROkupasi,
      comboRKonstruksiojk: record.comboRKonstruksiojk,
      comboMKabZonaGempa: record.comboMKabZonaGempa,
      comboMWilayah: record.comboMWilayah,
      comboRKodepos: record.comboRKodepos));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

	Future<void> onComboROkupasiChanged(
			ComboROkupasiChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboROkupasiModel comboROkupasi = event.comboROkupasi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboROkupasi: comboROkupasi));
	}

	Future<void> onComboRKonstruksiojkChanged(
			ComboRKonstruksiojkChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKonstruksiojkModel comboRKonstruksiojk = event.comboRKonstruksiojk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKonstruksiojk: comboRKonstruksiojk));
	}

	Future<void> onComboMBiindemnityOjkChanged(
			ComboMBiindemnityOjkChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBiindemnityOjkModel comboMBiindemnityOjk = event.comboMBiindemnityOjk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBiindemnityOjk: comboMBiindemnityOjk));
	}

	Future<void> onComboMKabZonaGempaChanged(
			ComboMKabZonaGempaChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMKabZonaGempa: comboMKabZonaGempa));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMWilayah: comboMWilayah));
	}

	Future<void> onComboMTarifojkBanjirParChanged(
			ComboMTarifojkBanjirParChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMTarifojkBanjirParModel comboMTarifojkBanjirPar = event.comboMTarifojkBanjirPar;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMTarifojkBanjirPar: comboMTarifojkBanjirPar));
	}

	Future<void> onComboRKodeposChanged(
			ComboRKodeposChangedEvent event, Emitter<SppaparCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKodeposModel comboRKodepos = event.comboRKodepos;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKodepos: comboRKodepos));
	}

}