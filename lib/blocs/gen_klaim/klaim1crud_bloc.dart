import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
import 'package:joss_app/repositories/gen_klaim/klaim1crud_repository.dart';

part 'klaim1crud_event.dart';
part 'klaim1crud_state.dart';

class Klaim1CrudBloc extends Bloc<Klaim1CrudEvents, Klaim1CrudState> {
	final Klaim1CrudRepository repository;
	Klaim1CrudBloc({required this.repository}) : super(const Klaim1CrudState()) {
		on<Klaim1CrudUbahEvent>(onUbahKlaim1Crud);
		on<Klaim1CrudTambahEvent>(onTambahKlaim1Crud);
		on<Klaim1CrudHapusEvent>(onHapusKlaim1Crud);
		on<Klaim1CrudLihatEvent>(onLihatKlaim1Crud);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<ComboMStsclaimChangedEvent>(onComboMStsclaimChanged);
	}

	Future<void> onTambahKlaim1Crud(
		Klaim1CrudTambahEvent event, Emitter<Klaim1CrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaim1CrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaim1Crud(
		Klaim1CrudUbahEvent event, Emitter<Klaim1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaim1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaim1Crud(
		Klaim1CrudHapusEvent event, Emitter<Klaim1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaim1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaim1Crud(
		Klaim1CrudLihatEvent event, Emitter<Klaim1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Klaim1CrudModel record = await repository.klaim1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<Klaim1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

	Future<void> onComboMStsclaimChanged(
			ComboMStsclaimChangedEvent event, Emitter<Klaim1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMStsclaimModel comboMStsclaim = event.comboMStsclaim;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMStsclaim: comboMStsclaim));
	}

}