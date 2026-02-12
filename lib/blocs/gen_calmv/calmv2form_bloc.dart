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
			if (returnData.success && returnData.data != null) {
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

		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv2Ubah AFTER emit(isSaving=true)",
		);

		try {
			final ok = await repository.calmv2FormUbah(event.record);
			final hasFailure = !ok;

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Ubah REPO DONE ok=$ok",
			);

			emit(state.copyWith(
				isSaving: false,
				isSaved: !hasFailure,
				hasFailure: hasFailure,
				record: event.record,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Ubah END "
						"emit(isSaving=false,isSaved=${!hasFailure},fail=$hasFailure)",
			);
		} catch (e) {
			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv2Ubah ERROR $e",
			);
			emit(state.copyWith(isSaving: false, isSaved: false, hasFailure: true));
		}
	}


	Future<void> onHapusCalmv2Form(
		Calmv2FormHapusEvent event, Emitter<Calmv2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv2FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalmv2Form(
		Calmv2FormLihatEvent event, Emitter<Calmv2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calmv2FormModel record = await repository.calmv2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}