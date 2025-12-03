import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv4form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv4form_repository.dart';

part 'regmv4form_event.dart';
part 'regmv4form_state.dart';

class Regmv4FormBloc extends Bloc<Regmv4FormEvents, Regmv4FormState> {
	final Regmv4FormRepository repository;
	Regmv4FormBloc({required this.repository}) : super(const Regmv4FormState()) {
		on<Regmv4FormUbahEvent>(onUbahRegmv4Form);
		on<Regmv4FormTambahEvent>(onTambahRegmv4Form);
		on<Regmv4FormHapusEvent>(onHapusRegmv4Form);
		on<Regmv4FormLihatEvent>(onLihatRegmv4Form);
	}

	Future<void> onTambahRegmv4Form(
			Regmv4FormTambahEvent event, Emitter<Regmv4FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regmv4FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure));
	}

	Future<void> onUbahRegmv4Form(
			Regmv4FormUbahEvent event, Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv4FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegmv4Form(
			Regmv4FormHapusEvent event, Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv4FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegmv4Form(
			Regmv4FormLihatEvent event, Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regmv4FormModel record = await repository.regmv4FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}