import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';
import 'package:joss_app/repositories/regother/regother1crud_repository.dart';
import '../../models/combobox/combomcobapp1_model.dart';

part 'regother1crud_event.dart';
part 'regother1crud_state.dart';

class Regother1CrudBloc extends Bloc<Regother1CrudEvents, Regother1CrudState> {
	final Regother1CrudRepository repository;
	Regother1CrudBloc({required this.repository}) : super(const Regother1CrudState()) {
		on<Regother1CrudUbahEvent>(onUbahRegother1Crud);
		on<Regother1CrudTambahEvent>(onTambahRegother1Crud);
		on<Regother1CrudHapusEvent>(onHapusRegother1Crud);
		on<Regother1CrudLihatEvent>(onLihatRegother1Crud);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<ComboMCobApp1ChangedEvent>(onComboMCobApp1Changed);
	}

	Future<void> onTambahRegother1Crud(
		Regother1CrudTambahEvent event, Emitter<Regother1CrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regother1CrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegother1Crud(
		Regother1CrudUbahEvent event, Emitter<Regother1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regother1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegother1Crud(
		Regother1CrudHapusEvent event, Emitter<Regother1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regother1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegother1Crud(
		Regother1CrudLihatEvent event, Emitter<Regother1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regother1CrudModel record = await repository.regother1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<Regother1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

	Future<void> onComboMCobApp1Changed(
			ComboMCobApp1ChangedEvent event, Emitter<Regother1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMCobApp1Model comboMCobApp1 = event.comboMCobApp1;
		emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				comboMCobApp1: comboMCobApp1));
	}

}