import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regpar/regpar6form_model.dart';
import 'package:joss_app/repositories/regpar/regpar6form_repository.dart';

part 'regpar6form_event.dart';
part 'regpar6form_state.dart';

class Regpar6FormBloc extends Bloc<Regpar6FormEvents, Regpar6FormState> {
	final Regpar6FormRepository repository;
	Regpar6FormBloc({required this.repository}) : super(const Regpar6FormState()) {
		on<Regpar6FormUbahEvent>(onUbahRegpar6Form);
		on<Regpar6FormTambahEvent>(onTambahRegpar6Form);
		on<Regpar6FormHapusEvent>(onHapusRegpar6Form);
		on<Regpar6FormLihatEvent>(onLihatRegpar6Form);
	}

	Future<void> onTambahRegpar6Form(
		Regpar6FormTambahEvent event, Emitter<Regpar6FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regpar6FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegpar6Form(
		Regpar6FormUbahEvent event, Emitter<Regpar6FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar6FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegpar6Form(
		Regpar6FormHapusEvent event, Emitter<Regpar6FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar6FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar6Form(
		Regpar6FormLihatEvent event, Emitter<Regpar6FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar6FormModel record = await repository.regpar6FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}