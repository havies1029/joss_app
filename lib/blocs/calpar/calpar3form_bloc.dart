import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
		on<Calpar3DraftEvent>(onDraftCalpar3Crud);
	}

	Future<void> onDraftCalpar3Crud(
			Calpar3DraftEvent event,
			Emitter<Calpar3FormState> emit,
			) async {
		debugPrint('[onDraftCalpar3Crud] event masuk');
		debugPrint('[onDraftCalpar3Crud] event.record = ${event.record}');

		emit(state.copyWith(
			record: event.record,
		));

		debugPrint('[onDraftCalpar3Crud] emit selesai, state.record sekarang = ${state.copyWith(record: event.record).record}');
	}

	Future<void> onTambahCalpar3Form(
			Calpar3FormTambahEvent event,
			Emitter<Calpar3FormState> emit,
			) async {
		debugPrint("=== [BLOC] CALPAR3 FORM TAMBAH ===");

		debugPrint("Event diterima: Calpar3FormTambahEvent");
		debugPrint("Record dikirim (toJson): ${event.record.toJson()}");

		ReturnDataAPI returnData;
		bool hasFailure = true;

		// SEBELUM SAVING
		emit(state.copyWith(isSaving: true, isSaved: false));
		debugPrint("State: isSaving=true, isSaved=false");

		try {
			debugPrint("Memanggil repository.calpar3FormTambah...");
			returnData = await repository.calpar3FormTambah(event.record);

			debugPrint("=== [API RESPONSE] CALPAR3 FORM TAMBAH ===");
			debugPrint("Success   : ${returnData.success}");
			debugPrint("Row Count : ${returnData.rowcount}");
			debugPrint("Data      : ${returnData.data}");
			debugPrint("=========================================");

			hasFailure = !returnData.success;

			// 🔥 UPDATE RECORD DENGAN ID BARU DARI API
			Calpar3FormModel updatedRecord = event.record.copyWith(
				calpar3Id: returnData.data.toString(),
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure,
				record: updatedRecord,
			));


		} catch (e, stack) {
			debugPrint("=== [BLOC ERROR] CALPAR3 FORM TAMBAH ===");
			debugPrint("Error : $e");
			debugPrint("Stack : $stack");
			debugPrint("========================================");

			hasFailure = true;

			// emit tetap, tapi record null
			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: true,
				record: null,
			));
		}

		debugPrint("=== [BLOC END] CALPAR3 FORM TAMBAH ===\n");
	}


	Future<void> onUbahCalpar3Form(
			Calpar3FormUbahEvent event,
			Emitter<Calpar3FormState> emit,
			) async {
		debugPrint("=== [BLOC] CALPAR3 FORM UBAH ===");
		debugPrint("Event diterima: Calpar3FormUbahEvent");
		debugPrint("Record dikirim (toJson): ${event.record.toJson()}");

		emit(state.copyWith(isSaving: true, isSaved: false));

		try {
			debugPrint("Memanggil repository.calpar3FormUbah...");
			final ReturnDataAPI returnData =
			await repository.calpar3FormUbah(event.record);

			debugPrint("=== [API RESPONSE] CALPAR3 FORM UBAH ===");
			debugPrint("Success   : ${returnData.success}");
			debugPrint("Row Count : ${returnData.rowcount}");
			debugPrint("Data      : ${returnData.data}");
			debugPrint("=======================================");

			final hasFailure = !returnData.success;

			// ✅ kalau data ada → update id
			// ✅ kalau data kosong → pertahankan id lama
			final incomingId = returnData.data.trim();
			final fixedId =
			incomingId.isNotEmpty ? incomingId : event.record.calpar3Id;

			final Calpar3FormModel updatedRecord =
			event.record.copyWith(calpar3Id: fixedId);

			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure,
				record: updatedRecord,
				returnData: returnData,
			));
		} catch (e, stack) {
			debugPrint("=== [BLOC ERROR] CALPAR3 FORM UBAH ===");
			debugPrint("Error : $e");
			debugPrint("Stack : $stack");
			debugPrint("======================================");

			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: true,
				record: null,
			));
		}

		debugPrint("=== [BLOC END] CALPAR3 FORM UBAH ===\n");
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