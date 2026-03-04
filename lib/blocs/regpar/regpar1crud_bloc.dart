import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';
import 'package:joss_app/repositories/regpar/regpar1crud_repository.dart';

part 'regpar1crud_event.dart';
part 'regpar1crud_state.dart';

class Regpar1CrudBloc extends Bloc<Regpar1CrudEvents, Regpar1CrudState> {
	final Regpar1CrudRepository repository;
	Regpar1CrudBloc({required this.repository}) : super(const Regpar1CrudState()) {
		on<Regpar1CrudUbahEvent>(onUbahRegpar1Crud);
		on<Regpar1CrudTambahEvent>(onTambahRegpar1Crud);
		on<Regpar1CrudHapusEvent>(onHapusRegpar1Crud);
		on<Regpar1CrudLihatEvent>(onLihatRegpar1Crud);
		on<Regpar1DraftEvent>(onDraftRegpar1Crud);
	}

	Future<void> onDraftRegpar1Crud(
			Regpar1DraftEvent event,
			Emitter<Regpar1CrudState> emit,
			) async {

		emit(state.copyWith(
			record: event.record,
			isSaved: false,
			hasFailure: false,
		));
	}

	Future<void> onTambahRegpar1Crud(
			Regpar1CrudTambahEvent event,
			Emitter<Regpar1CrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ReturnDataAPI returnData =
		await repository.regpar1CrudTambah(event.record);

		final bool hasFailure = !returnData.success;

		if (!hasFailure) {
			// 🔥 ambil regpar1Id baru dari server
			final newId = returnData.data.toString() ?? "";

			// 🔥 update record
			final updatedRecord = event.record;
			updatedRecord.regpar1Id = newId;

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

	Future<void> onUbahRegpar1Crud(
			Regpar1CrudUbahEvent event,
			Emitter<Regpar1CrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final bool hasFailure = !await repository.regpar1CrudUbah(event.record);

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: event.record,
		));
	}


	Future<void> onHapusRegpar1Crud(
		Regpar1CrudHapusEvent event, Emitter<Regpar1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar1Crud(
		Regpar1CrudLihatEvent event, Emitter<Regpar1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar1CrudModel record = await repository.regpar1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}