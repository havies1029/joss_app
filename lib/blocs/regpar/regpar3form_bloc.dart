import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/regpar/regpar3form_model.dart';
import 'package:joss_app/repositories/regpar/regpar3form_repository.dart';

part 'regpar3form_event.dart';
part 'regpar3form_state.dart';

class Regpar3FormBloc extends Bloc<Regpar3FormEvents, Regpar3FormState> {
	final Regpar3FormRepository repository;
	Regpar3FormBloc({required this.repository}) : super(const Regpar3FormState()) {
		on<Regpar3FormUbahEvent>(onUbahRegpar3Form);
		on<Regpar3FormTambahEvent>(onTambahRegpar3Form);
		on<Regpar3FormHapusEvent>(onHapusRegpar3Form);
		on<Regpar3FormLihatEvent>(onLihatRegpar3Form);
		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
		on<Regpar3DraftEvent>(onDraftRegpar3Crud);
	}

	Future<void> onDraftRegpar3Crud(
			Regpar3DraftEvent event,
			Emitter<Regpar3FormState> emit,
			) async {

		emit(state.copyWith(
			record: event.record,
			isSaved: false,
			hasFailure: false,
		));
	}

	Future<void> onTambahRegpar3Form(
			Regpar3FormTambahEvent event,
			Emitter<Regpar3FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.regpar3FormTambah(event.record);

		final bool hasFailure = !returnData.success;

		if (!hasFailure) {
			// 🔥 ambil id baru dari server
			final newId = returnData.data.toString() ?? "";

			// 🔥 update record (model mutable)
			final updatedRecord = event.record;
			updatedRecord.regpar3Id = newId; // <- sesuaikan nama field id

			emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: false,
				record: updatedRecord, // << PENTING
			));
		} else {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
			));
		}
	}

	Future<void> onUbahRegpar3Form(
			Regpar3FormUbahEvent event,
			Emitter<Regpar3FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final bool hasFailure = !await repository.regpar3FormUbah(event.record);

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: event.record, // penting biar state pegang data terbaru
		));
	}


	Future<void> onHapusRegpar3Form(
			Regpar3FormHapusEvent event, Emitter<Regpar3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar3FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar3Form(
			Regpar3FormLihatEvent event, Emitter<Regpar3FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar3FormModel record = await repository.regpar3FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record,
				comboMJnscoverPar: record.comboMJnscoverPar,
				comboMWilayah: record.comboMWilayah,
				comboMKabZonaGempa: record.comboMKabZonaGempa));
	}

	Future<void> onComboMJnscoverParChanged(
			ComboMJnscoverParChangedEvent event, Emitter<Regpar3FormState> emit) async {

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
				comboMJnscoverPar: comboMJnscoverPar,
				record: record));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<Regpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMWilayah: comboMWilayah));
	}

	Future<void> onComboMKabZonaGempaChanged(
			ComboMKabZonaGempaChangedEvent event, Emitter<Regpar3FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMKabZonaGempa: comboMKabZonaGempa));
	}

}