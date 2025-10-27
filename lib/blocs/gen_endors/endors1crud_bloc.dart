import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_endors/endors1crud_model.dart';
import 'package:joss_app/repositories/gen_endors/endors1crud_repository.dart';

part 'endors1crud_event.dart';
part 'endors1crud_state.dart';

class Endors1CrudBloc extends Bloc<Endors1CrudEvents, Endors1CrudState> {
	final Endors1CrudRepository repository;
	Endors1CrudBloc({required this.repository}) : super(const Endors1CrudState()) {
		on<Endors1CrudUbahEvent>(onUbahEndors1Crud);
		on<Endors1CrudTambahEvent>(onTambahEndors1Crud);
		on<Endors1CrudHapusEvent>(onHapusEndors1Crud);
		on<Endors1CrudLihatEvent>(onLihatEndors1Crud);
	}

	Future<void> onTambahEndors1Crud(
		Endors1CrudTambahEvent event, Emitter<Endors1CrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.endors1CrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahEndors1Crud(
		Endors1CrudUbahEvent event, Emitter<Endors1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.endors1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusEndors1Crud(
		Endors1CrudHapusEvent event, Emitter<Endors1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.endors1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatEndors1Crud(
		Endors1CrudLihatEvent event, Emitter<Endors1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Endors1CrudModel record = await repository.endors1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}