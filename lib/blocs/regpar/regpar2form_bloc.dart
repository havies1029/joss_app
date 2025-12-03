import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';
import 'package:joss_app/repositories/regpar/regpar2form_repository.dart';

part 'regpar2form_event.dart';
part 'regpar2form_state.dart';

class Regpar2FormBloc extends Bloc<Regpar2FormEvents, Regpar2FormState> {
	final Regpar2FormRepository repository;
	Regpar2FormBloc({required this.repository}) : super(const Regpar2FormState()) {
		on<Regpar2FormUbahEvent>(onUbahRegpar2Form);
		on<Regpar2FormTambahEvent>(onTambahRegpar2Form);
		on<Regpar2FormHapusEvent>(onHapusRegpar2Form);
		on<Regpar2FormLihatEvent>(onLihatRegpar2Form);
		on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
		on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
	}

	Future<void> onTambahRegpar2Form(
		Regpar2FormTambahEvent event, Emitter<Regpar2FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regpar2FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegpar2Form(
		Regpar2FormUbahEvent event, Emitter<Regpar2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar2FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegpar2Form(
		Regpar2FormHapusEvent event, Emitter<Regpar2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar2FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar2Form(
		Regpar2FormLihatEvent event, Emitter<Regpar2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar2FormModel record = await repository.regpar2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboROkupasiChanged(
			ComboROkupasiChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboROkupasiModel comboROkupasi = event.comboROkupasi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboROkupasi: comboROkupasi));
	}

	Future<void> onComboRKonstruksiojkChanged(
			ComboRKonstruksiojkChangedEvent event, Emitter<Regpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKonstruksiojkModel comboRKonstruksiojk = event.comboRKonstruksiojk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKonstruksiojk: comboRKonstruksiojk));
	}

}