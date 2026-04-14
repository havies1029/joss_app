import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regpar/regpar5form_model.dart';
import 'package:joss_app/repositories/regpar/regpar5form_repository.dart';

part 'regpar5form_event.dart';
part 'regpar5form_state.dart';

class Regpar5FormBloc extends Bloc<Regpar5FormEvents, Regpar5FormState> {
	final Regpar5FormRepository repository;
	Regpar5FormBloc({required this.repository}) : super(const Regpar5FormState()) {
		on<Regpar5FormUbahEvent>(onUbahRegpar5Form);
		on<Regpar5FormTambahEvent>(onTambahRegpar5Form);
		on<Regpar5FormHapusEvent>(onHapusRegpar5Form);
		on<Regpar5FormLihatEvent>(onLihatRegpar5Form);
		on<Regpar5FormHitungPremiEvent>(onHitungPremiRegpar5Form);
	}

	Future<void> onTambahRegpar5Form(
		Regpar5FormTambahEvent event, Emitter<Regpar5FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regpar5FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegpar5Form(
		Regpar5FormUbahEvent event, Emitter<Regpar5FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar5FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegpar5Form(
		Regpar5FormHapusEvent event, Emitter<Regpar5FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar5FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar5Form(
		Regpar5FormLihatEvent event, Emitter<Regpar5FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar5FormModel record = await repository.regpar5FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onHitungPremiRegpar5Form(
			Regpar5FormHitungPremiEvent event,
			Emitter<Regpar5FormState> emit) async {
		emit(state.copyWith(isCalculating: true, isCalculated: false));


		try {
			Regpar5FormModel record = await repository.regpar5FormHitungPremi(event.recordId);
			emit(state.copyWith(
				isCalculating: false,
				isCalculated: true,
				record: record,
			));

		} catch (e) {
			emit(state.copyWith(
				isCalculating: false,
				isCalculated: false,
			));
		}
	}
}