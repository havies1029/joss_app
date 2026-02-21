import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';

import '../../models/combobox/combommvpakai_model.dart';
import '../../models/combobox/combormatauang_model.dart';

part 'calmv1crud_event.dart';
part 'calmv1crud_state.dart';

class Calmv1CrudBloc extends Bloc<Calmv1CrudEvents, Calmv1CrudState> {
	final Calmv1CrudRepository repository;
	Calmv1CrudBloc({required this.repository}) : super(const Calmv1CrudState()) {
		on<Calmv1CrudUbahEvent>(onUbahCalmv1Crud);
		on<Calmv1CrudTambahEvent>(onTambahCalmv1Crud);
		on<Calmv1CrudHapusEvent>(onHapusCalmv1Crud);
		on<Calmv1CrudLihatEvent>(onLihatCalmv1Crud);
		on<ComboMMvgrupOjkChangedEvent>(onComboMMvgrupOjkChanged);
		on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMMvpakaiChangedEvent>(onComboMMvpakaiChanged);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<FieldCoverBulanChangedEvent>(onFieldCoverBulanChanged);
		on<FieldHargaChangedEvent>(onFieldHargaChanged);
		on<FieldCurrIdChangedEvent>(onFieldCurrIdChanged);
		on<FieldThnBuatChangedEvent>(onFieldThnBuatChanged);
		on<Calmv1DraftEvent>(onDraftCalmv1Crud);
		on<Calmv1ResetStatusEvent>((event, emit) {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: false,
			));
		});
		on<ClaimmvPolisAutoSaveEvent>(onCalmvPolisAutoSave);
	}

	Future<void> onDraftCalmv1Crud(
			Calmv1DraftEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional kalau mau reset flag:
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahCalmv1Crud(
			Calmv1CrudTambahEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		try {
			final returnData = await repository.calmv1CrudTambah(event.record);

			final hasFailure = !returnData.success;

			Calmv1CrudModel newRecord = event.record;
			if (returnData.success && returnData.data != null) {
				newRecord = event.record.copyWith(calmv1Id: returnData.data.toString());
			}


			emit(state.copyWith(
				isSaving: false,
				// ⚠️ saran konsisten:
				isSaved: returnData.success,
				hasFailure: hasFailure,
				record: newRecord,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Tambah END "
						"emit(isSaving=false,isSaved=${returnData.success},fail=$hasFailure) "
						"finalId=${newRecord.calmv1Id}",
			);
		} catch (e) {
			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Tambah ERROR $e",
			);
			emit(state.copyWith(isSaving: false, isSaved: false, hasFailure: true));
		}
	}

	Future<void> onUbahCalmv1Crud(
			Calmv1CrudUbahEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv1Ubah START "
					"id=${event.record.calmv1Id} hash=${event.record.hashCode}",
		);

		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv1Ubah AFTER emit(isSaving=true) "
					"state.isSaving=${state.isSaving} state.isSaved=${state.isSaved} state.fail=${state.hasFailure}",
		);

		try {
			final ok = await repository.calmv1CrudUbah(event.record);
			final hasFailure = !ok;

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Ubah REPO DONE ok=$ok",
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: !hasFailure,
				hasFailure: hasFailure,
				record: event.record,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Ubah END "
						"emit(isSaving=false,isSaved=${!hasFailure},fail=$hasFailure)",
			);
		} catch (e) {
			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Ubah ERROR $e",
			);
			emit(state.copyWith(isSaving: false, isSaved: false, hasFailure: true));
		}
	}



	Future<void> onHapusCalmv1Crud(
		Calmv1CrudHapusEvent event, Emitter<Calmv1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalmv1Crud(
		Calmv1CrudLihatEvent event, Emitter<Calmv1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calmv1CrudModel record = await repository.calmv1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMMvjnscoverChanged(
			ComboMMvjnscoverChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(isDirty: false));

		final ComboMMvjnscoverModel? combo = event.comboMMvjnscover;

		Calmv1CrudModel updatedRecord = state.record ?? Calmv1CrudModel.empty();
		updatedRecord = updatedRecord.copyWith(
			mmvjnscoverId: combo?.mmvjnscoverId, // aman kalau null
		);

		emit(state.copyWith(
			comboMMvjnscover: combo,
			record: updatedRecord,
			isDirty: true,
			isValid: _validate(updatedRecord),
		));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(isDirty: false));

		final ComboMWilayahModel? combo = event.comboMWilayah;

		Calmv1CrudModel updatedRecord = state.record ?? Calmv1CrudModel.empty();
		updatedRecord = updatedRecord.copyWith(
			mwilayahId: combo?.mwilayahId,
		);

		emit(state.copyWith(
			comboMWilayah: combo,
			record: updatedRecord,
			isDirty: true,
			isValid: _validate(updatedRecord),
		));
	}

	Future<void> onComboMMvgrupOjkChanged(
			ComboMMvgrupOjkChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(isDirty: false));

		final ComboMMvgrupOjkModel? combo = event.comboMMvgrupOjk;

		Calmv1CrudModel updatedRecord = state.record ?? Calmv1CrudModel.empty();
		updatedRecord = updatedRecord.copyWith(
			mmvgrupojkId: combo?.mmvgrupojkId,
		);

		emit(state.copyWith(
			comboMMvgrupOjk: combo,
			record: updatedRecord,
			isDirty: true,
			isValid: _validate(updatedRecord),
		));
	}

	Future<void> onComboMMvpakaiChanged(
			ComboMMvpakaiChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		emit(state.copyWith(isDirty: false));

		final ComboMMvpakaiModel? combo = event.comboMMvpakai;

		Calmv1CrudModel updatedRecord = state.record ?? Calmv1CrudModel.empty();
		updatedRecord = updatedRecord.copyWith(
			mmvpakaiId: combo?.mmvpakaiId,
		);

		emit(state.copyWith(
			comboMMvpakaiModel: combo,
			record: updatedRecord,
			isDirty: true,
			isValid: _validate(updatedRecord),
		));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {

		emit(state.copyWith(isDirty: false));


		ComboRMatauangModel comboRMatauang = event.comboRMatauang;


		Calmv1CrudModel updatedRecord = state.record ?? Calmv1CrudModel.empty();

		updatedRecord = updatedRecord.copyWith(
			currId: comboRMatauang.rmatauangKode,
		);

		emit(state.copyWith(
			comboRMatauangModel: comboRMatauang,
			record: updatedRecord,
			isDirty: true,
			isValid: _validate(updatedRecord),
		));
	}

	Future<void> onFieldCoverBulanChanged(
			FieldCoverBulanChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		final record = state.record ?? Calmv1CrudModel.empty();

		emit(state.copyWith(
			record: record.copyWith(coverBulan: event.coverBulan),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldHargaChanged(
			FieldHargaChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		final record = state.record ?? Calmv1CrudModel.empty();

		emit(state.copyWith(
			record: record.copyWith(harga: event.harga),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldCurrIdChanged(
			FieldCurrIdChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		final record = state.record ?? Calmv1CrudModel.empty();

		emit(state.copyWith(
			record: record.copyWith(currId: event.currId),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldThnBuatChanged(
			FieldThnBuatChangedEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {
		final record = state.record ?? Calmv1CrudModel.empty();

		emit(state.copyWith(
			record: record.copyWith(thnBuat: event.thnBuat),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onCalmvPolisAutoSave(
			ClaimmvPolisAutoSaveEvent event,
			Emitter<Calmv1CrudState> emit,
			) async {

		if (!state.isDirty) {
			debugPrint("AUTO SAVE ⛔ skip karena state.isDirty = false");
			return;
		}

		Calmv1CrudModel? record = state.record;
		if (record == null) {
			debugPrint("AUTO SAVE ⛔ skip karena record = null");
			return;
		}

		debugPrint("AUTO SAVE ▶️ mulai save | id: ${record.calmv1Id}");

		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		try {
			/// ===== TAMBAH (INSERT) =====
			if (record.calmv1Id.trim().isEmpty) {
				debugPrint("AUTO SAVE ➕ mode TAMBAH");

				final returnData = await repository.calmv1CrudTambah(record);

				debugPrint("AUTO SAVE ➕ hasil tambah success: ${returnData.success}");
				debugPrint("AUTO SAVE ➕ returned id: ${returnData.data}");

				if (!returnData.success || returnData.data == null) {
					debugPrint("AUTO SAVE ❌ tambah gagal");

					emit(state.copyWith(
						isSaving: false,
						isSaved: false,
						hasFailure: true,
						isDirty: true,
					));
					return;
				}

				record = record.copyWith(calmv1Id: returnData.data.toString());
				debugPrint("AUTO SAVE ➕ id baru dipasang: ${record.calmv1Id}");
			}

			/// ===== UBAH (UPDATE) =====
			debugPrint("AUTO SAVE ✏️ mode UBAH id: ${record.calmv1Id}");
			final ok = await repository.calmv1CrudUbah(record);

			debugPrint("AUTO SAVE ✏️ hasil ubah success: $ok");

			emit(state.copyWith(
				isSaving: false,
				isSaved: ok,
				hasFailure: !ok,
				record: record,
				isDirty: ok ? false : true,
			));

			debugPrint("AUTO SAVE ✅ selesai | saved: $ok");
		} catch (e) {
			debugPrint("AUTO SAVE 💥 ERROR: $e");

			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
				isDirty: true,
			));
		}
	}

	bool _validate(Calmv1CrudModel? record) {
		if (record == null) return false;
		// record.calmv1Id.isNotEmpty &&
		return
				record.coverBulan > 0 &&
				record.currId.isNotEmpty &&
				record.harga > 0 &&
				record.thnBuat > 0 &&
				record.mmvgrupojkId?.isNotEmpty == true &&
				record.mmvjnscoverId?.isNotEmpty == true &&
				record.mmvpakaiId?.isNotEmpty == true &&
				record.mwilayahId?.isNotEmpty == true;
	}
}