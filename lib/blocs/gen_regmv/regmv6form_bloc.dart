import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv6form_repository.dart';

part 'regmv6form_event.dart';
part 'regmv6form_state.dart';

class Regmv6FormBloc extends Bloc<Regmv6FormEvents, Regmv6FormState> {
	final Regmv6FormRepository repository;
	Regmv6FormBloc({required this.repository}) : super(const Regmv6FormState()) {
		on<Regmv6FormUbahEvent>(onUbahRegmv6Form);
		on<Regmv6FormTambahEvent>(onTambahRegmv6Form);
		on<Regmv6FormHapusEvent>(onHapusRegmv6Form);
		on<Regmv6FormLihatEvent>(onLihatRegmv6Form);
		on<Regmv6FormHitungPremiEvent>(onHitungPremiRegmv6Form);
	}

	Future<void> onTambahRegmv6Form(
			Regmv6FormTambahEvent event, Emitter<Regmv6FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regmv6FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure));
	}

	Future<void> onUbahRegmv6Form(
			Regmv6FormUbahEvent event, Emitter<Regmv6FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv6FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegmv6Form(
			Regmv6FormHapusEvent event, Emitter<Regmv6FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv6FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv6Form(
			Regmv6FormLihatEvent event, Emitter<Regmv6FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv6FormModel record = await repository.regmv6FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onHitungPremiRegmv6Form(
			Regmv6FormHitungPremiEvent event,
			Emitter<Regmv6FormState> emit,
			) async {
		debugPrint('[Regmv6] HITUNG PREMI TRIGGERED');
		debugPrint('[Regmv6] regmv1Id: ${event.regmv1Id}');

		emit(state.copyWith(isCalculating: true, isCalculated: false));

		try {
			debugPrint('[Regmv6] CALLING repository.regmv6FormHitungPremi');

			final record =
			await repository.regmv6FormHitungPremi(event.regmv1Id);

			debugPrint('[Regmv6] HITUNG PREMI SUCCESS');
			debugPrint('[Regmv6] record: $record');

			emit(state.copyWith(
				isCalculating: false,
				isCalculated: true,
				record: record,
			));
		} catch (e, st) {
			debugPrint('[Regmv6] HITUNG PREMI ERROR: $e');
			debugPrintStack(stackTrace: st);

			emit(state.copyWith(
				isCalculating: false,
				isCalculated: false,
			));
		}
	}


}