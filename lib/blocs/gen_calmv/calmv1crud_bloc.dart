import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';

part 'calmv1crud_event.dart';
part 'calmv1crud_state.dart';

class Calmv1CrudBloc extends Bloc<Calmv1CrudEvents, Calmv1CrudState> {
	final Calmv1CrudRepository repository;
	Calmv1CrudBloc({required this.repository}) : super(const Calmv1CrudState()) {
		on<Calmv1CrudUbahEvent>(onUbahCalmv1Crud);
		on<Calmv1CrudTambahEvent>(onTambahCalmv1Crud);
		on<Calmv1CrudHapusEvent>(onHapusCalmv1Crud);
		on<Calmv1CrudLihatEvent>(onLihatCalmv1Crud);
		on<CalmvtoRegMvEvent>(onCalmvToReg);
		on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMMvgrupOjkChangedEvent>(onComboMMvgrupOjkChanged);
	}

	Future<void> onTambahCalmv1Crud(
			Calmv1CrudTambahEvent event, Emitter<Calmv1CrudState> emit) async {

		debugPrint("🟢 [BLOC] onTambahCalmv1Crud triggered");
		emit(state.copyWith(isSaving: true, isSaved: false));

		final returnData = await repository.calmv1CrudTambah(event.record);

		debugPrint("📩 Response dari repository:");
		debugPrint("➡️ success=${returnData.success}");
		debugPrint("➡️ data=${returnData.data}");
		debugPrint("➡️ rowcount=${returnData.rowcount}");

		bool hasFailure = !returnData.success;

		// ⬇️ FIX: kalau backend ngirim data sebagai string, simpan manual ke record
		Calmv1CrudModel newRecord = event.record;
		if (returnData.success && returnData.data is String) {
			newRecord = event.record.copyWith(calmv1Id: returnData.data.toString());
			debugPrint("✅ Set calmv1Id dari response string: ${newRecord.calmv1Id}");
		}

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: newRecord,
		));
	}

	Future<void> onUbahCalmv1Crud(
		Calmv1CrudUbahEvent event, Emitter<Calmv1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
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

	Future<void> onCalmvToReg(
			CalmvtoRegMvEvent event, Emitter<Calmv1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmMvToRegMv(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
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