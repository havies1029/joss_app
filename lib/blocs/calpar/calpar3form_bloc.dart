import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';
import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';

<<<<<<< HEAD
import '../../models/combobox/combomjnscoverpar_model.dart';

=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
part 'calpar3form_event.dart';
part 'calpar3form_state.dart';

class Calpar3FormBloc extends Bloc<Calpar3FormEvents, Calpar3FormState> {
	final Calpar3FormRepository repository;
	Calpar3FormBloc({required this.repository}) : super(const Calpar3FormState()) {
		on<Calpar3FormUbahEvent>(onUbahCalpar3Form);
		on<Calpar3FormTambahEvent>(onTambahCalpar3Form);
		on<Calpar3FormHapusEvent>(onHapusCalpar3Form);
		on<Calpar3FormLihatEvent>(onLihatCalpar3Form);
<<<<<<< HEAD
		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
	}

<<<<<<< HEAD
=======
	// Future<void> onTambahCalpar3Form(
	// 	Calpar3FormTambahEvent event, Emitter<Calpar3FormState> emit) async {
	//
	// 	ReturnDataAPI returnData;
	// 	bool hasFailure = true;
	// 	emit(state.copyWith(isSaving: true, isSaved: false));
	// 	returnData = await repository.calpar3FormTambah(event.record);
	// 	hasFailure = !returnData.success;
	// 	emit(state.copyWith(
	// 		isSaving: false,
	// 		isSaved: true,
	// 		hasFailure: hasFailure));
	// }

>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	Future<void> onTambahCalpar3Form(
			Calpar3FormTambahEvent event,
			Emitter<Calpar3FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false));

<<<<<<< HEAD
		final returnData = await repository.calpar3FormTambah(event.record);
		final hasFailure = !returnData.success;

		// Ambil ID baru dari response API (biasanya 'data')
		final newId = returnData.data?.toString() ?? "";

		// Build record final dengan ID yang baru disimpan
		final savedRecord = Calpar3FormModel(
			calpar3Id: newId,
			calpar1Id: event.record.calpar1Id,
=======
		final ReturnDataAPI returnData = await repository.calpar3FormTambah(event.record);

		final hasFailure = !returnData.success;

		final newId = returnData.data?.toString() ?? "";

		final savedRecord = Calpar3FormModel(
			calpar3Id: newId,
			calpar1Id: event.record.calpar1Id,

>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			isEq: event.record.isEq,
			isTsfwd: event.record.isTsfwd,
			rateEqvet: event.record.rateEqvet,
			rateOther: event.record.rateOther,
			ratePar: event.record.ratePar,
			rateRsmdcc: event.record.rateRsmdcc,
			rateTotal: event.record.rateTotal,
			rateTsfwd: event.record.rateTsfwd,
<<<<<<< HEAD
			kab2zonagempaId: event.record.kab2zonagempaId,
			comboMKabZonaGempa: event.record.comboMKabZonaGempa,
			mjnscoverparId: event.record.mjnscoverparId,
			comboMJnscoverPar: event.record.comboMJnscoverPar,
			mwilayahId: event.record.mwilayahId,
=======

			comboMKabZonaGempa: event.record.comboMKabZonaGempa,
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			comboMWilayah: event.record.comboMWilayah,
		);

		emit(state.copyWith(
			isSaving: false,
<<<<<<< HEAD
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: savedRecord,
		));
	}


	Future<void> onUbahCalpar3Form(
			Calpar3FormUbahEvent event, Emitter<Calpar3FormState> emit) async {
=======
			isSaved: true,
			hasFailure: hasFailure,
			record: savedRecord,
			returnData: returnData,
		));
	}

	Future<void> onUbahCalpar3Form(
		Calpar3FormUbahEvent event, Emitter<Calpar3FormState> emit) async {
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar3FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusCalpar3Form(
<<<<<<< HEAD
			Calpar3FormHapusEvent event, Emitter<Calpar3FormState> emit) async {
=======
		Calpar3FormHapusEvent event, Emitter<Calpar3FormState> emit) async {
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar3FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalpar3Form(
<<<<<<< HEAD
			Calpar3FormLihatEvent event, Emitter<Calpar3FormState> emit) async {
=======
		Calpar3FormLihatEvent event, Emitter<Calpar3FormState> emit) async {
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calpar3FormModel record = await repository.calpar3FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

<<<<<<< HEAD
	Future<void> onComboMJnscoverParChanged(
			ComboMJnscoverParChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMJnscoverParModel comboMJnscoverPar = event.comboMJnscoverPar;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMJnscoverPar: comboMJnscoverPar));
	}

=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
<<<<<<< HEAD
				isLoading: false,
				isLoaded: true,
				comboMWilayah: comboMWilayah));
=======
			isLoading: false,
			isLoaded: true,
			comboMWilayah: comboMWilayah));
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	}

	Future<void> onComboMKabZonaGempaChanged(
			ComboMKabZonaGempaChangedEvent event, Emitter<Calpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
		emit(state.copyWith(
<<<<<<< HEAD
				isLoading: false,
				isLoaded: true,
				comboMKabZonaGempa: comboMKabZonaGempa));
=======
			isLoading: false,
			isLoaded: true,
			comboMKabZonaGempa: comboMKabZonaGempa));
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	}

}