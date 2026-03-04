import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/models/gen_klaim/klaim2crud_model.dart';
import 'package:joss_app/repositories/gen_klaim/klaim2crud_repository.dart';

part 'klaim2crud_event.dart';
part 'klaim2crud_state.dart';

class Klaim2CrudBloc extends Bloc<Klaim2CrudEvents, Klaim2CrudState> {
	final Klaim2CrudRepository repository;
	Klaim2CrudBloc({required this.repository}) : super(const Klaim2CrudState()) {
		on<Klaim2CrudUbahEvent>(onUbahKlaim2Crud);
		on<Klaim2CrudTambahEvent>(onTambahKlaim2Crud);
		on<Klaim2CrudHapusEvent>(onHapusKlaim2Crud);
		on<Klaim2CrudLihatEvent>(onLihatKlaim2Crud);
		on<ComboMStsclaimChangedEvent>(onComboMStsclaimChanged);
	}

	Future<void> onTambahKlaim2Crud(
		Klaim2CrudTambahEvent event, Emitter<Klaim2CrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaim2CrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaim2Crud(
		Klaim2CrudUbahEvent event, Emitter<Klaim2CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaim2CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaim2Crud(
		Klaim2CrudHapusEvent event, Emitter<Klaim2CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaim2CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaim2Crud(
		Klaim2CrudLihatEvent event, Emitter<Klaim2CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Klaim2CrudModel record = await repository.klaim2CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMStsclaimChanged(
			ComboMStsclaimChangedEvent event, Emitter<Klaim2CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMStsclaimModel comboMStsclaim = event.comboMStsclaim;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMStsclaim: comboMStsclaim));
	}

}