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
	}
	Future<void> onTambahCalmv2Form(
			Calmv2FormTambahEvent event,
			Emitter<Calmv2FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false));

		final ReturnDataAPI returnData = await repository.calmv2FormTambah(event.record);

		final hasFailure = !returnData.success;

		// ✔ ID yang dikembalikan API
		final newId = returnData.data?.toString() ?? "";

		// ✔ Build record final dengan ID baru
		final savedRecord = Calmv2FormModel(
			calmv2Id: newId,
			calmv1Id: event.record.calmv1Id,
			aw: event.record.aw,
			isEq: event.record.isEq,
			isFlood: event.record.isFlood,
			isSrcc: event.record.isSrcc,
			isTbod: event.record.isTbod,
			isTerrorism: event.record.isTerrorism,
			pad: event.record.pad,
			pap: event.record.pap,
			passangerCount: event.record.passangerCount,
			pll: event.record.pll,
			tpl: event.record.tpl,
		);

		// ✔ Emit ke UI
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: savedRecord,
			returnData: returnData,
		));
	}

	Future<void> onUbahCalmv2Form(
		Calmv2FormUbahEvent event, Emitter<Calmv2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv2FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
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