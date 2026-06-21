import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/repositories/gen_calmv/calmv2form_repository.dart';

part 'calmv2form_event.dart';
part 'calmv2form_state.dart';

class Calmv2FormBloc extends Bloc<Calmv2FormEvents, Calmv2FormState> {
	final Calmv2FormRepository repository;
	Calmv2FormBloc({required this.repository}) : super(const Calmv2FormState()) {
		on<Calmv2FormUbahEvent>(onUbahCalmv2Form);
		on<Calmv2FormTambahEvent>(onTambahCalmv2Form);
		on<Calmv2FormHapusEvent>(onHapusCalmv2Form);
		on<Calmv2FormLihatEvent>(onLihatCalmv2Form);
		on<Calmv2FormDraftEvent>(onDraftCalmv2Form);
		on<Calmv2ResetStatusEvent>((event, emit) {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: false,
			));
		});
		on<FieldPadChangedEvent>(onFieldPadChanged);
		on<FieldPapChangedEvent>(onFieldPapChanged);
		on<FieldPllChangedEvent>(onFieldPllChanged);
		on<FieldTplChangedEvent>(onFieldTplChanged);

		on<FieldIsEqChangedEvent>(onFieldIsEqChanged);
		on<FieldIsFloodChangedEvent>(onFieldIsFloodChanged);
		on<FieldIsSrccChangedEvent>(onFieldIsSrccChanged);
		on<FieldIsTbodChangedEvent>(onFieldIsTbodChanged);
		on<FieldIsTerrorismChangedEvent>(onFieldIsTerrorismChanged);

		on<FieldPassengerCountChangedEvent>(onFieldPassengerCountChanged);
		on<FieldCalmv1IdChangedEvent>(onFieldCalmv1IdChanged);
// autosave (opsional)
		on<Calmv2AutoSaveEvent>(onCalmv2AutoSave);
	}

	Future<void> onDraftCalmv2Form(
			Calmv2FormDraftEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional: reset flags kalau kamu pakai flag utk submit
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahCalmv2Form(
			Calmv2FormTambahEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv2Tambah START "
					"parentId=${event.record.calmv1Id} oldId=${event.record.calmv2Id} "
					"hash=${event.record.hashCode}",
		);

		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv2Tambah AFTER emit(isSaving=true)",
		);

		try {
			final ReturnDataAPI returnData =
			await repository.calmv2FormTambah(event.record);

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Tambah REPO DONE "
						"success=${returnData.success} data=${returnData.data}",
			);

			var newRecord = event.record;
			if (returnData.success) {
				final newId = returnData.data.toString();
				if (newId.isNotEmpty) {
					newRecord = event.record.copyWith(calmv2Id: newId);
				}
			}

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Tambah BEFORE FINAL emit "
						"newId=${newRecord.calmv2Id}",
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: returnData.success,
				hasFailure: !returnData.success,
				record: newRecord,
				returnData: returnData,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Tambah END "
						"emit(isSaving=false,isSaved=${returnData.success},fail=${!returnData.success}) "
						"finalId=${newRecord.calmv2Id}",
			);
		} catch (e) {
			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Tambah ERROR $e",
			);
			emit(state.copyWith(isSaving: false, isSaved: false, hasFailure: true));
		}
	}

	Future<void> onUbahCalmv2Form(
			Calmv2FormUbahEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv2Ubah START "
					"parentId=${event.record.calmv1Id} calmv2Id=${event.record.calmv2Id}",
		);

		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		try {
			final ReturnDataAPI returnData =
			await repository.calmv2FormUbah(event.record);

			final incomingId = returnData.data.toString().trim();

			final fixedId = incomingId.isNotEmpty
					? incomingId
					: event.record.calmv2Id;

			final fixedRecord = event.record.copyWith(
				calmv2Id: fixedId,
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: returnData.success,
				hasFailure: !returnData.success,
				record: fixedRecord,
				returnData: returnData,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Ubah END "
						"success=${returnData.success} finalId=${fixedRecord.calmv2Id}",
			);
		} catch (e) {
			debugPrint("[${DateTime.now().toIso8601String()}] Calmv2Ubah ERROR $e");

			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
			));
		}
	}

	Future<void> onHapusCalmv2Form(
			Calmv2FormHapusEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.calmv2FormHapus(event.recordId);

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: !returnData.success,
			returnData: returnData,
		));
	}

	Future<void> onLihatCalmv2Form(
		Calmv2FormLihatEvent event, Emitter<Calmv2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calmv2FormModel record = await repository.calmv2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onFieldPadChanged(
			FieldPadChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(pad: event.pad),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldPapChanged(
			FieldPapChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(pap: event.pap),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldPllChanged(
			FieldPllChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(pll: event.pll),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldTplChanged(
			FieldTplChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(tpl: event.tpl),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldIsEqChanged(
			FieldIsEqChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(isEq: event.isEq),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldIsFloodChanged(
			FieldIsFloodChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(isFlood: event.isFlood),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldIsSrccChanged(
			FieldIsSrccChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(isSrcc: event.isSrcc),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldIsTbodChanged(
			FieldIsTbodChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(isTbod: event.isTbod),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldIsTerrorismChanged(
			FieldIsTerrorismChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(isTerrorism: event.isTerrorism),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldPassengerCountChanged(
			FieldPassengerCountChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(passangerCount: event.passangerCount),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onFieldCalmv1IdChanged(
			FieldCalmv1IdChangedEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		Calmv2FormModel? record = state.record ?? Calmv2FormModel.empty();
		emit(state.copyWith(
			record: record.copyWith(calmv1Id: event.calmv1Id),
			isDirty: true,
			isValid: _validate(record),
		));
	}

	Future<void> onCalmv2AutoSave(
			Calmv2AutoSaveEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		if (!state.isDirty) {
			debugPrint("CALMV2 AUTO SAVE ⛔ skip (isDirty=false)");
			return;
		}

		final current = state.record;
		if (current == null) {
			debugPrint("CALMV2 AUTO SAVE ⛔ skip (record=null)");
			return;
		}

		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		try {
			final ReturnDataAPI returnData =
			await repository.calmv2FormUbah(current);

			final incomingId = returnData.data.toString().trim();

			final fixedRecord = current.copyWith(
				calmv2Id: incomingId.isNotEmpty
						? incomingId
						: current.calmv2Id,
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: returnData.success,
				hasFailure: !returnData.success,
				record: fixedRecord,
				isDirty: returnData.success ? false : true,
				returnData: returnData,
			));
		} catch (e) {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
				isDirty: true,
			));
		}
	}

	bool _validate(Calmv2FormModel? record) {
		if (record == null) return false;

		final hasCoverage =
				record.isEq ||
						record.isFlood ||
						record.isSrcc ||
						record.isTbod ||
						record.isTerrorism;

		final isValid =
				record.calmv1Id.isNotEmpty &&
						record.pad > 0 &&
						record.pap > 0 &&
						record.pll > 0 &&
						record.tpl > 0 &&
						record.passangerCount > 0 &&
						hasCoverage;

		debugPrint("=== CALMV2 VALIDATION DEBUG ===");
		debugPrint("calmv1Id : ${record.calmv1Id}");
		debugPrint("pad      : ${record.pad}");
		debugPrint("pap      : ${record.pap}");
		debugPrint("pll      : ${record.pll}");
		debugPrint("tpl      : ${record.tpl}");
		debugPrint("passenger: ${record.passangerCount}");
		debugPrint("coverage : EQ=${record.isEq}, Flood=${record.isFlood}, SRCC=${record.isSrcc}, TBOD=${record.isTbod}, Terror=${record.isTerrorism}");
		debugPrint("hasCoverage : $hasCoverage");
		debugPrint("RESULT VALID : $isValid");

		return isValid;
	}
}