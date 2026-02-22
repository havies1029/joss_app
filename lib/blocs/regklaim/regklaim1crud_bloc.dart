import 'package:flutter/cupertino.dart';
import 'package:joss_app/models/combobox/combominsurance_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regklaim/regklaim1crud_model.dart';
import 'package:joss_app/repositories/regklaim/regklaim1crud_repository.dart';

part 'regklaim1crud_event.dart';
part 'regklaim1crud_state.dart';

class Regklaim1CrudBloc extends Bloc<Regklaim1CrudEvents, Regklaim1CrudState> {
	final Regklaim1CrudRepository repository;
	Regklaim1CrudBloc({required this.repository}) : super(const Regklaim1CrudState()) {
		on<Regklaim1CrudUbahEvent>(onUbahRegklaim1Crud);
		on<Regklaim1CrudTambahEvent>(onTambahRegklaim1Crud);
		on<Regklaim1CrudHapusEvent>(onHapusRegklaim1Crud);
		on<Regklaim1CrudLihatEvent>(onLihatRegklaim1Crud);
    on<Regklaim1Tambah4PolisJpsEvent>(onTambah4PolisJps);
		on<ComboMInsuranceChangedEvent>(onComboMInsuranceChanged);
	}

	Future<void> onTambahRegklaim1Crud(
			Regklaim1CrudTambahEvent event,
			Emitter<Regklaim1CrudState> emit,
			) async {

		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
			regklaim1Id: "",
		));

		final returnData = await repository.regklaim1CrudTambah(event.record);

		final hasFailure = !returnData.success;

		final newId = (!hasFailure)
				? returnData.data.toString()
				: "";

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			viewMode: hasFailure ? "tambah" : "ubah",
			regklaim1Id: newId,
		));
	}



	Future<void> onUbahRegklaim1Crud(
		Regklaim1CrudUbahEvent event, Emitter<Regklaim1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regklaim1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegklaim1Crud(
		Regklaim1CrudHapusEvent event, Emitter<Regklaim1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regklaim1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegklaim1Crud(
		Regklaim1CrudLihatEvent event, Emitter<Regklaim1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regklaim1CrudModel record = await repository.regklaim1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

  Future<void> onTambah4PolisJps(
    Regklaim1Tambah4PolisJpsEvent event, Emitter<Regklaim1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
    ReturnDataAPI returnData = await repository.regklaim1Tambah4PolisJps(event.sppa1Id);
    bool hasFailure = !returnData.success;
    emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onComboMInsuranceChanged(
			ComboMInsuranceChangedEvent event, Emitter<Regklaim1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMInsuranceModel comboMInsurance = event.comboMInsurance;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMInsurance: comboMInsurance));
	}

}