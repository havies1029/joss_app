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
		on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMMvgrupOjkChangedEvent>(onComboMMvgrupOjkChanged);
		on<Calmv1DraftEvent>(onDraftCalmv1Crud);
		on<Calmv1ResetStatusEvent>((event, emit) {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: false,
			));
		});
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
		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv1Tambah START "
					"oldId=${event.record.calmv1Id} hash=${event.record.hashCode}",
		);

		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv1Tambah AFTER emit(isSaving=true) "
					"state.isSaving=${state.isSaving} state.isSaved=${state.isSaved} state.fail=${state.hasFailure}",
		);

		try {
			final returnData = await repository.calmv1CrudTambah(event.record);

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Tambah REPO DONE "
						"success=${returnData.success} data=${returnData.data}",
			);

			final hasFailure = !returnData.success;

			Calmv1CrudModel newRecord = event.record;
			if (returnData.success && returnData.data != null) {
				newRecord = event.record.copyWith(calmv1Id: returnData.data.toString());
			}

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv1Tambah BEFORE FINAL emit "
						"newId=${newRecord.calmv1Id} hasFailure=$hasFailure",
			);

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
			ComboMMvjnscoverChangedEvent event, Emitter<Calmv1CrudState> emit) async {

		debugPrint("🔄 [Bloc] Combo Jenis Cover changed: ${event.comboMMvjnscover.mmvjnscoverId}");
		emit(state.copyWith(comboMMvjnscover: event.comboMMvjnscover));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<Calmv1CrudState> emit) async {

		debugPrint("🔄 [Bloc] Combo Wilayah changed: ${event.comboMWilayah.mwilayahId}");
		emit(state.copyWith(comboMWilayah: event.comboMWilayah));
	}

	Future<void> onComboMMvgrupOjkChanged(
			ComboMMvgrupOjkChangedEvent event, Emitter<Calmv1CrudState> emit) async {

		debugPrint("🔄 [Bloc] Combo OJK changed: ${event.comboMMvgrupOjk.mmvgrupojkId}");
		emit(state.copyWith(comboMMvgrupOjk: event.comboMMvgrupOjk));
	}


}