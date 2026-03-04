import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv7form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv7form_repository.dart';

part 'regmv7form_event.dart';
part 'regmv7form_state.dart';

class Regmv7FormBloc extends Bloc<Regmv7FormEvents, Regmv7FormState> {
	final Regmv7FormRepository repository;
	Regmv7FormBloc({required this.repository}) : super(const Regmv7FormState()) {
		on<Regmv7FormUbahEvent>(onUbahRegmv7Form);
		on<Regmv7FormTambahEvent>(onTambahRegmv7Form);
		on<Regmv7FormHapusEvent>(onHapusRegmv7Form);
		on<Regmv7FormLihatEvent>(onLihatRegmv7Form);
	}

	Future<void> onTambahRegmv7Form(
		Regmv7FormTambahEvent event, Emitter<Regmv7FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regmv7FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegmv7Form(
		Regmv7FormUbahEvent event, Emitter<Regmv7FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv7FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegmv7Form(
		Regmv7FormHapusEvent event, Emitter<Regmv7FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv7FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv7Form(
		Regmv7FormLihatEvent event, Emitter<Regmv7FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv7FormModel record = await repository.regmv7FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}