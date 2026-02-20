import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';
import 'package:joss_app/models/combobox/combomkelurahan_model.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';
import 'package:joss_app/repositories/regpar/regpar2form_repository.dart';

part 'regpar2form_event.dart';
part 'regpar2form_state.dart';

class Regpar2FormBloc extends Bloc<Regpar2FormEvents, Regpar2FormState> {
	final Regpar2FormRepository repository;
	Regpar2FormBloc({required this.repository}) : super(const Regpar2FormState()) {
		on<Regpar2FormUbahEvent>(onUbahRegpar2Form);
		on<Regpar2FormTambahEvent>(onTambahRegpar2Form);
		on<Regpar2FormHapusEvent>(onHapusRegpar2Form);
		on<Regpar2FormLihatEvent>(onLihatRegpar2Form);
		on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
		on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
		on<ComboMPropinsiChangedEvent>(onComboMPropinsiChanged);
		on<ComboMKotaChangedEvent>(onComboMKotaChanged);
		on<ComboMKecamatanChangedEvent>(onComboMKecamatanChanged);
		on<ComboMKelurahanChangedEvent>(onComboMKelurahanChanged);
		on<FieldPolisMulaiChangedEvent>(onFieldPolisMulaiChanged);
		on<FieldPolisAkhirChangedEvent>(onFieldPolisAkhirChanged);
		on<FieldObjectAlamatChangedEvent>(onFieldObjectAlamatChangedEvent);
		on<Regpar2DraftEvent>(onDraftRegpar2Crud);
	}

	Future<void> onDraftRegpar2Crud(
			Regpar2DraftEvent event,
			Emitter<Regpar2FormState> emit,
			) async {

		emit(state.copyWith(
			record: event.record,
			isSaved: false,
			hasFailure: false,
		));
	}

	Future<void> onTambahRegpar2Form(
			Regpar2FormTambahEvent event,
			Emitter<Regpar2FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.regpar2FormTambah(event.record);

		final bool hasFailure = !returnData.success;

		if (!hasFailure) {
			// 🔥 ambil id baru dari server
			final newId = returnData.data.toString() ?? "";

			// 🔥 update record (model mutable)
			final updatedRecord = event.record;
			updatedRecord.regpar2Id = newId; // <- sesuaikan nama field id

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

	Future<void> onUbahRegpar2Form(
			Regpar2FormUbahEvent event,
			Emitter<Regpar2FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final bool hasFailure = !await repository.regpar2FormUbah(event.record);

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: event.record, // penting biar state pegang data terbaru
		));
	}

	Future<void> onHapusRegpar2Form(
			Regpar2FormHapusEvent event, Emitter<Regpar2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar2FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar2Form(
			Regpar2FormLihatEvent event, Emitter<Regpar2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar2FormModel record = await repository.regpar2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record,
			comboMKecamatan: record.comboMKecamatan,
			comboMKelurahan: record.comboMKelurahan,
			comboMKota: record.comboMKota,
			comboMPropinsi: record.comboMPropinsi,
			comboRKonstruksiojk: record.comboRKonstruksiojk,
			comboROkupasi: record.comboROkupasi,
		));
	}

	Future<void> onComboROkupasiChanged(
			ComboROkupasiChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboROkupasiModel comboROkupasi = event.comboROkupasi;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboROkupasi: comboROkupasi));
	}

	Future<void> onComboRKonstruksiojkChanged(
			ComboRKonstruksiojkChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKonstruksiojkModel comboRKonstruksiojk = event.comboRKonstruksiojk;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboRKonstruksiojk: comboRKonstruksiojk));
	}

	Future<void> onComboMPropinsiChanged(
			ComboMPropinsiChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMPropinsiModel comboMPropinsi = event.comboMPropinsi;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMPropinsi: comboMPropinsi));
	}

	Future<void> onComboMKotaChanged(
			ComboMKotaChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKotaModel comboMKota = event.comboMKota;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMKota: comboMKota));
	}

	Future<void> onComboMKecamatanChanged(
			ComboMKecamatanChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKecamatanModel comboMKecamatan = event.comboMKecamatan;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMKecamatan: comboMKecamatan));
	}

	Future<void> onComboMKelurahanChanged(
			ComboMKelurahanChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMKelurahanModel comboMKelurahan = event.comboMKelurahan;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMKelurahan: comboMKelurahan));
	}

	Future<void> onFieldPolisMulaiChanged(
			FieldPolisMulaiChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		DateTime polisMulai = event.polisMulai;
		var record = state.record?.copyWith(polisMulai: polisMulai);

		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: record));
	}

	Future<void> onFieldPolisAkhirChanged(
			FieldPolisAkhirChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		DateTime polisAkhir = event.polisAkhir;
		var record = state.record?.copyWith(polisAkhir: polisAkhir);

		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: record));
	}

	Future<void> onFieldObjectAlamatChangedEvent(
			FieldObjectAlamatChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		String objectAlamat = event.objectAlamat;
		var record = state.record?.copyWith(objectAlamat: objectAlamat);

		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: record));
	}

}