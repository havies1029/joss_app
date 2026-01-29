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
		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		final ReturnDataAPI returnData =
		await repository.calmv2FormTambah(event.record);

		var newRecord = event.record;

		if (returnData.success && returnData.data != null) {
			final newId = returnData.data.toString();
			if (newId.isNotEmpty) {
				newRecord = event.record.copyWith(calmv2Id: newId);
			}
		}

		debugPrint("✅ saved calmv2Id: ${newRecord.calmv2Id}");

		emit(state.copyWith(
			isSaving: false,
			isSaved: returnData.success,
			hasFailure: !returnData.success,
			record: newRecord,
			returnData: returnData,
		));
	}


	Future<void> onUbahCalmv2Form(
			Calmv2FormUbahEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ok = await repository.calmv2FormUbah(event.record);
		final hasFailure = !ok;

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,   // ✅ jangan true kalau gagal
			hasFailure: hasFailure,
			record: event.record,   // ✅ update record di state
		));

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