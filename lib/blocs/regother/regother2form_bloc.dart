import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regother/regother2form_model.dart';
import 'package:joss_app/repositories/regother/regother2form_repository.dart';

part 'regother2form_event.dart';
part 'regother2form_state.dart';

class Regother2FormBloc extends Bloc<Regother2FormEvents, Regother2FormState> {
	final Regother2FormRepository repository;
	Regother2FormBloc({required this.repository}) : super(const Regother2FormState()) {
		on<Regother2FormUbahEvent>(onUbahRegother2Form);
		on<Regother2FormTambahEvent>(onTambahRegother2Form);
		on<Regother2FormHapusEvent>(onHapusRegother2Form);
		on<Regother2FormLihatEvent>(onLihatRegother2Form);
	}

	Future<void> onTambahRegother2Form(
		Regother2FormTambahEvent event, Emitter<Regother2FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regother2FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegother2Form(
		Regother2FormUbahEvent event, Emitter<Regother2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regother2FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegother2Form(
		Regother2FormHapusEvent event, Emitter<Regother2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regother2FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegother2Form(
		Regother2FormLihatEvent event, Emitter<Regother2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regother2FormModel record = await repository.regother2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}