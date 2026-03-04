import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';
import 'package:joss_app/repositories/gen_calmv/calmv3form_repository.dart';


part 'calmv3form_event.dart';
part 'calmv3form_state.dart';

class Calmv3FormBloc extends Bloc<Calmv3FormEvents, Calmv3FormState> {
	final Calmv3FormRepository repository;
	Calmv3FormBloc({required this.repository}) : super(const Calmv3FormState()) {
		on<Calmv3FormUbahEvent>(onUbahCalmv3Form);
		on<Calmv3FormTambahEvent>(onTambahCalmv3Form);
		on<Calmv3FormHapusEvent>(onHapusCalmv3Form);
		on<Calmv3FormLihatEvent>(onLihatCalmv3Form);
		on<Calmv3FormLoadDataEvent>(onLoadDataCalmv3Form);
		on<Calmv3FormHitungPremiEvent>(onHitungPremiCalmv3Form);
		on<Calmv3FormDraftEvent>(onDraftCalmv3Form);
		on<Calmv3ResetStatusEvent>((event, emit) {
			emit(state.copyWith(
				isLoading: false,
				isLoaded: false,
				isSaving: false,
				isSaved: false,
				hasFailure: false,
			));
		});

	}

	Future<void> onDraftCalmv3Form(
			Calmv3FormDraftEvent event,
			Emitter<Calmv3FormState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional: kalau kamu mau draft ini gak dianggap save
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahCalmv3Form(
		Calmv3FormTambahEvent event, Emitter<Calmv3FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.calmv3FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahCalmv3Form(
		Calmv3FormUbahEvent event, Emitter<Calmv3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv3FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusCalmv3Form(
		Calmv3FormHapusEvent event, Emitter<Calmv3FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calmv3FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalmv3Form(
			Calmv3FormLihatEvent event, Emitter<Calmv3FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calmv3FormModel record = await repository.calmv3FormLihat(event.calmv1Id);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onLoadDataCalmv3Form(
			Calmv3FormLoadDataEvent event,
			Emitter<Calmv3FormState> emit,
			) async {
		emit(state.copyWith(isLoading: true, isLoaded: false, isSaved: false));

		try {
			final record = await repository.calmv3FormLihat(event.calmv1Id);

			emit(state.copyWith(
				record: record,
				isLoading: false,
				isLoaded: true,
				hasFailure: false,
			));

			final result = await repository.calmv3FormTambah(record);
			emit(state.copyWith(isSaved: true, hasFailure: !result.success));

		} catch (e) {
			emit(state.copyWith(isLoading: false, hasFailure: true));
		}
	}

	Future<void> onHitungPremiCalmv3Form(
			Calmv3FormHitungPremiEvent event,
			Emitter<Calmv3FormState> emit,
			) async {
		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi START "
					"calmv1Id=${event.calmv1Id}",
		);

		emit(state.copyWith(isLoading: true, isLoaded: false));

		debugPrint(
			"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi AFTER emit(isLoading=true) "
					"state.isLoading=${state.isLoading} state.isLoaded=${state.isLoaded}",
		);

		try {
			final result = await repository.calmv3FormHitungPremi(event.calmv1Id);

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi REPO DONE "
						"resultHash=${result.hashCode}",
			);

			emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: result,
			));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi END "
						"emit(isLoading=false,isLoaded=true)",
			);
		} catch (e) {
			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi ERROR $e",
			);

			emit(state.copyWith(isLoading: false, isLoaded: false));

			debugPrint(
				"[${DateTime.now().toIso8601String()}] Calmv3HitungPremi END "
						"emit(isLoading=false,isLoaded=false)",
			);
		}
	}

}