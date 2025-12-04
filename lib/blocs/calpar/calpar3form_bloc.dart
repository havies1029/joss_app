// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
// import 'package:joss_app/models/combobox/combomwilayah_model.dart';
// import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
// import 'package:joss_app/models/calpar/calpar3form_model.dart';
// import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';
//
// import '../../models/combobox/combomjnscoverpar_model.dart';
//
// part 'calpar3form_event.dart';
// part 'calpar3form_state.dart';
//
// class Calpar3FormBloc extends Bloc<Calpar3FormEvents, Calpar3FormState> {
// 	final Calpar3FormRepository repository;
// 	Calpar3FormBloc({required this.repository}) : super(const Calpar3FormState()) {
// 		on<Calpar3FormUbahEvent>(onUbahCalpar3Form);
// 		on<Calpar3FormTambahEvent>(onTambahCalpar3Form);
// 		on<Calpar3FormHapusEvent>(onHapusCalpar3Form);
// 		on<Calpar3FormLihatEvent>(onLihatCalpar3Form);
// 		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
// 		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
// 		on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
// 	}
//
// 	Future<void> onTambahCalpar3Form(
// 			Calpar3FormTambahEvent event,
// 			Emitter<Calpar3FormState> emit,
// 			) async {
// 		emit(state.copyWith(isSaving: true, isSaved: false));
//
// 		final returnData = await repository.calpar3FormTambah(event.record);
// 		final hasFailure = !returnData.success;
//
// 		// Ambil ID baru dari response API (biasanya 'data')
// 		final newId = returnData.data?.toString() ?? "";
//
// 		// Build record final dengan ID yang baru disimpan
// 		final savedRecord = Calpar3FormModel(
// 			calpar3Id: newId,
// 			calpar1Id: event.record.calpar1Id,
// 			isEq: event.record.isEq,
// 			isTsfwd: event.record.isTsfwd,
// 			rateEqvet: event.record.rateEqvet,
// 			rateOther: event.record.rateOther,
// 			ratePar: event.record.ratePar,
// 			rateRsmdcc: event.record.rateRsmdcc,
// 			rateTotal: event.record.rateTotal,
// 			rateTsfwd: event.record.rateTsfwd,
// 			kab2zonagempaId: event.record.kab2zonagempaId,
// 			comboMKabZonaGempa: event.record.comboMKabZonaGempa,
// 			mjnscoverparId: event.record.mjnscoverparId,
// 			comboMJnscoverPar: event.record.comboMJnscoverPar,
// 			mwilayahId: event.record.mwilayahId,
// 			comboMWilayah: event.record.comboMWilayah,
// 		);
//
// 		emit(state.copyWith(
// 			isSaving: false,
// 			isSaved: !hasFailure,
// 			hasFailure: hasFailure,
// 			record: savedRecord,
// 		));
// 	}
//
//
// 	Future<void> onUbahCalpar3Form(
// 			Calpar3FormUbahEvent event, Emitter<Calpar3FormState> emit) async {
// 		emit(state.copyWith(isSaving: true, isSaved: false));
// 		bool hasFailure = !await repository.calpar3FormUbah(event.record);
// 		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
// 	}
//
// 	Future<void> onHapusCalpar3Form(
// 			Calpar3FormHapusEvent event, Emitter<Calpar3FormState> emit) async {
// 		emit(state.copyWith(isSaving: true, isSaved: false));
// 		bool hasFailure = !await repository.calpar3FormHapus(event.recordId);
// 		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
// 	}
//
// 	Future<void> onLihatCalpar3Form(
// 			Calpar3FormLihatEvent event, Emitter<Calpar3FormState> emit) async {
// 		emit(state.copyWith(isLoading: true, isLoaded: false));
// 		Calpar3FormModel record = await repository.calpar3FormLihat(event.recordId);
// 		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
// 	}
//
// 	Future<void> onComboMJnscoverParChanged(
// 			ComboMJnscoverParChangedEvent event, Emitter<Calpar3FormState> emit) async {
//
// 		emit(state.copyWith(isLoading: true, isLoaded: false));
//
// 		ComboMJnscoverParModel comboMJnscoverPar = event.comboMJnscoverPar;
// 		emit(state.copyWith(
// 				isLoading: false,
// 				isLoaded: true,
// 				comboMJnscoverPar: comboMJnscoverPar));
// 	}
//
// 	Future<void> onComboMWilayahChanged(
// 			ComboMWilayahChangedEvent event, Emitter<Calpar3FormState> emit) async {
//
// 		emit(state.copyWith(isLoading: true, isLoaded: false));
//
// 		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
// 		emit(state.copyWith(
// 				isLoading: false,
// 				isLoaded: true,
// 				comboMWilayah: comboMWilayah));
// 	}
//
// 	Future<void> onComboMKabZonaGempaChanged(
// 			ComboMKabZonaGempaChangedEvent event, Emitter<Calpar3FormState> emit) async {
//
// 		emit(state.copyWith(isLoading: true, isLoaded: false));
//
// 		ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
// 		emit(state.copyWith(
// 				isLoading: false,
// 				isLoaded: true,
// 				comboMKabZonaGempa: comboMKabZonaGempa));
// 	}
//
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';
import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';

part 'calpar3form_event.dart';
part 'calpar3form_state.dart';

class Calpar3FormBloc extends Bloc<Calpar3FormEvents, Calpar3FormState> {
	final Calpar3FormRepository repository;
	Calpar3FormBloc({required this.repository}) : super(const Calpar3FormState()) {
		on<Calpar3FormUbahEvent>(onUbahCalpar3Form);
		on<Calpar3FormTambahEvent>(onTambahCalpar3Form);
		on<Calpar3FormHapusEvent>(onHapusCalpar3Form);
		on<Calpar3FormLihatEvent>(onLihatCalpar3Form);
		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
	}

	Future<void> onTambahCalpar3Form(
			Calpar3FormTambahEvent event, Emitter<Calpar3FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.calpar3FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure));
	}

	Future<void> onUbahCalpar3Form(
			Calpar3FormUbahEvent event, Emitter<Calpar3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar3FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusCalpar3Form(
			Calpar3FormHapusEvent event, Emitter<Calpar3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar3FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalpar3Form(
			Calpar3FormLihatEvent event, Emitter<Calpar3FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calpar3FormModel record = await repository.calpar3FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record,
				comboMJnscoverPar: record.comboMJnscoverPar,
				comboMWilayah: record.comboMWilayah,
				comboMKabZonaGempa: record.comboMKabZonaGempa));
	}

	Future<void> onComboMJnscoverParChanged(
			ComboMJnscoverParChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMJnscoverParModel comboMJnscoverPar = event.comboMJnscoverPar;
		var record = state.record;
		record?.isEq = comboMJnscoverPar.isEq;
		record?.isFlexas = comboMJnscoverPar.isFlexas;
		record?.isOther = comboMJnscoverPar.isOther;
		record?.isRsmdcc = comboMJnscoverPar.isRsmdcc;
		record?.isTsfwd = comboMJnscoverPar.isTsfwd;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: record,
				comboMJnscoverPar: comboMJnscoverPar));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMWilayah: comboMWilayah));
	}

	Future<void> onComboMKabZonaGempaChanged(
			ComboMKabZonaGempaChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMKabZonaGempa: comboMKabZonaGempa));
	}

}