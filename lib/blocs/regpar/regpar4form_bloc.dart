import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/regpar/regpar4form_model.dart';
import 'package:joss_app/repositories/regpar/regpar4form_repository.dart';

part 'regpar4form_event.dart';
part 'regpar4form_state.dart';

class Regpar4FormBloc extends Bloc<Regpar4FormEvents, Regpar4FormState> {
	final Regpar4FormRepository repository;
	Regpar4FormBloc({required this.repository}) : super(const Regpar4FormState()) {
		on<Regpar4FormUbahEvent>(onUbahRegpar4Form);
		on<Regpar4FormTambahEvent>(onTambahRegpar4Form);
		on<Regpar4FormHapusEvent>(onHapusRegpar4Form);
		on<Regpar4FormLihatEvent>(onLihatRegpar4Form);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
	}

	Future<void> onTambahRegpar4Form(
		Regpar4FormTambahEvent event, Emitter<Regpar4FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regpar4FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegpar4Form(
		Regpar4FormUbahEvent event, Emitter<Regpar4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar4FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegpar4Form(
		Regpar4FormHapusEvent event, Emitter<Regpar4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regpar4FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegpar4Form(
		Regpar4FormLihatEvent event, Emitter<Regpar4FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regpar4FormModel record = await repository.regpar4FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<Regpar4FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

}