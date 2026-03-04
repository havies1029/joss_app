import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv1crud_repository.dart';

part 'regmv1crud_event.dart';
part 'regmv1crud_state.dart';

class Regmv1CrudBloc extends Bloc<Regmv1CrudEvents, Regmv1CrudState> {
	final Regmv1CrudRepository repository;
	Regmv1CrudBloc({required this.repository}) : super(const Regmv1CrudState()) {
		on<Regmv1CrudUbahEvent>(onUbahRegmv1Crud);
		on<Regmv1CrudTambahEvent>(onTambahRegmv1Crud);
		on<Regmv1CrudHapusEvent>(onHapusRegmv1Crud);
		on<Regmv1CrudLihatEvent>(onLihatRegmv1Crud);
		on<Regmv1DraftEvent>(onDraftRegmv1Crud);
	}

	Future<void> onDraftRegmv1Crud(
			Regmv1DraftEvent event,
			Emitter<Regmv1CrudState> emit,
			) async {

		emit(state.copyWith(
			record: event.record,
			isSaved: false,
			hasFailure: false,
		));
	}


	Future<void> onTambahRegmv1Crud(
			Regmv1CrudTambahEvent event,
			Emitter<Regmv1CrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.regmv1CrudTambah(event.record);

		final bool hasFailure = !returnData.success;

		if (!hasFailure) {
			// 🔥 ambil regmv1Id baru dari server
			final newId = returnData.data.toString() ?? "";
				debugPrint("🔥 [BLOC][REGMV1] new regmv1Id from API = $newId");

			// 🔥 update record di event (model kamu mutable kan)
			final updatedRecord = event.record;
			updatedRecord.regmv1Id = newId;

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

	Future<void> onUbahRegmv1Crud(
			Regmv1CrudUbahEvent event,
			Emitter<Regmv1CrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ok = await repository.regmv1CrudUbah(event.record);
		final hasFailure = !ok;

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: event.record, // penting biar state pegang data terbaru
		));


	}


	Future<void> onHapusRegmv1Crud(
		Regmv1CrudHapusEvent event, Emitter<Regmv1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv1Crud(
		Regmv1CrudLihatEvent event, Emitter<Regmv1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv1CrudModel record = await repository.regmv1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}