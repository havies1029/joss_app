import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv3form_repository.dart';

part 'regmv3form_event.dart';
part 'regmv3form_state.dart';

class Regmv3FormBloc extends Bloc<Regmv3FormEvents, Regmv3FormState> {
	final Regmv3FormRepository repository;
	Regmv3FormBloc({required this.repository}) : super(const Regmv3FormState()) {
		on<Regmv3FormUbahEvent>(onUbahRegmv3Form);
		on<Regmv3FormTambahEvent>(onTambahRegmv3Form);
		on<Regmv3FormHapusEvent>(onHapusRegmv3Form);
		on<Regmv3FormLihatEvent>(onLihatRegmv3Form);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMMvmerkChangedEvent>(onComboMMvmerkChanged);
		on<ComboMMvtipeChangedEvent>(onComboMMvtipeChanged);
		on<ComboMMvmodelChangedEvent>(onComboMMvmodelChanged);
		on<ComboMWarnaChangedEvent>(onComboMWarnaChanged);
		on<ComboMMvpakaiChangedEvent>(onComboMMvpakaiChanged);
		on<FieldThnBuatChangedEvent>(onFieldThnBuatChanged);
		on<FieldAksesorisChangedEvent>(onFieldAksesorisChanged);
		on<FieldHargaChangedEvent>(onFieldHargaChanged);
		on<FieldMesinNoChangedEvent>(onFieldMesinNoChanged);
		on<FieldPlatNoChangedEvent>(onFieldPlatNoChanged);
		on<FieldRangkaNoChangedEvent>(onFieldRangkaNoChanged);
		on<Regmv3DraftEvent>(onDraftRegmv3Crud);
	}

	Future<void> onDraftRegmv3Crud(
			Regmv3DraftEvent event,
			Emitter<Regmv3FormState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional kalau mau reset flag:
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahRegmv3Form(
			Regmv3FormTambahEvent event,
			Emitter<Regmv3FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.regmv3FormTambah(event.record);

		final bool hasFailure = !returnData.success;

		if (!hasFailure) {
			// 🔥 ambil regmv3Id baru dari server
			final newId = returnData.data?.toString() ?? "";
			debugPrint("🔥 [BLOC][REGMV3] new regmv3Id from API = $newId");

			// 🔥 update record di event (kalau mutable)
			final updatedRecord = event.record;
			updatedRecord.regmv3Id = newId;

			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: false,
				record: updatedRecord, // << penting buat UI
			));
		} else {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
			));
		}
	}

	Future<void> onUbahRegmv3Form(
		Regmv3FormUbahEvent event, Emitter<Regmv3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv3FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegmv3Form(
		Regmv3FormHapusEvent event, Emitter<Regmv3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv3FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv3Form(
		Regmv3FormLihatEvent event, Emitter<Regmv3FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv3FormModel record = await repository.regmv3FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMWilayah: comboMWilayah));
	}

	Future<void> onComboMMvmerkChanged(
			ComboMMvmerkChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvmerkModel comboMMvmerk = event.comboMMvmerk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvmerk: comboMMvmerk));
	}

	Future<void> onComboMMvtipeChanged(
			ComboMMvtipeChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvtipeModel comboMMvtipe = event.comboMMvtipe;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvtipe: comboMMvtipe));
	}

	Future<void> onComboMMvmodelChanged(
			ComboMMvmodelChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvmodelModel comboMMvmodel = event.comboMMvmodel;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvmodel: comboMMvmodel));
	}

	Future<void> onComboMWarnaChanged(
			ComboMWarnaChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWarnaModel comboMWarna = event.comboMWarna;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMWarna: comboMWarna));
	}

	Future<void> onComboMMvpakaiChanged(
			ComboMMvpakaiChangedEvent event, Emitter<Regmv3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvpakaiModel comboMMvpakai = event.comboMMvpakai;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvpakai: comboMMvpakai));
	}

	Future<void> onFieldThnBuatChanged(
			FieldThnBuatChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		int thnBuat = int.tryParse(event.thnBuat) ?? 0;
		record = record?.copyWith(thnBuat: thnBuat);

		emit(state.copyWith(
				record: record));
	}

	Future<void> onFieldAksesorisChanged(
			FieldAksesorisChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		record = record?.copyWith(aksesoris: event.aksesoris);

		emit(state.copyWith(
				record: record));
	}

	Future<void> onFieldHargaChanged(
			FieldHargaChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		double harga = double.tryParse(event.harga) ?? 0.0;
		record = record?.copyWith(harga: harga);

		emit(state.copyWith(
				record: record));
	}

	Future<void> onFieldMesinNoChanged(
			FieldMesinNoChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		record = record?.copyWith(mesinNo: event.mesinNo);

		emit(state.copyWith(
				record: record));
	}

	Future<void> onFieldPlatNoChanged(
			FieldPlatNoChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		record = record?.copyWith(platNo: event.platNo);

		emit(state.copyWith(
				record: record));
	}

	Future<void> onFieldRangkaNoChanged(
			FieldRangkaNoChangedEvent event, Emitter<Regmv3FormState> emit) async {

		Regmv3FormModel? record = state.record;
		record = record?.copyWith(rangkaNo: event.rangkaNo);

		emit(state.copyWith(
				record: record));
	}

}