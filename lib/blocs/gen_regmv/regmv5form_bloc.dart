import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv5form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv5form_repository.dart';

part 'regmv5form_event.dart';
part 'regmv5form_state.dart';

class Regmv5FormBloc extends Bloc<Regmv5FormEvents, Regmv5FormState> {
	final Regmv5FormRepository repository;
	Regmv5FormBloc({required this.repository}) : super(const Regmv5FormState()) {
		on<Regmv5FormUbahEvent>(onUbahRegmv5Form);
		on<Regmv5FormTambahEvent>(onTambahRegmv5Form);
		on<Regmv5FormHapusEvent>(onHapusRegmv5Form);
		on<Regmv5FormLihatEvent>(onLihatRegmv5Form);
	}

	Future<void> onTambahRegmv5Form(
			Regmv5FormTambahEvent event, Emitter<Regmv5FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regmv5FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure));
	}

	Future<void> onUbahRegmv5Form(
			Regmv5FormUbahEvent event, Emitter<Regmv5FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv5FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegmv5Form(
			Regmv5FormHapusEvent event, Emitter<Regmv5FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv5FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv5Form(
			Regmv5FormLihatEvent event, Emitter<Regmv5FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv5FormModel record = await repository.regmv5FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}