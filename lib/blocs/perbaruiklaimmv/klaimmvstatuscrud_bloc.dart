//generate from : usp_flutter_crud_bloc

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscrud_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvstatuscrud_repository.dart';

part 'klaimmvstatuscrud_event.dart';
part 'klaimmvstatuscrud_state.dart';

class KlaimmvstatuscrudBloc extends Bloc<KlaimmvstatuscrudEvents, KlaimmvstatuscrudState> {
	final KlaimmvstatuscrudRepository repository;
	KlaimmvstatuscrudBloc({required this.repository}) : super(const KlaimmvstatuscrudState()) {
		on<KlaimmvstatuscrudUbahEvent>(onUbahKlaimmvstatuscrud);
		on<KlaimmvstatuscrudTambahEvent>(onTambahKlaimmvstatuscrud);
		on<KlaimmvstatuscrudHapusEvent>(onHapusKlaimmvstatuscrud);
		on<KlaimmvstatuscrudLihatEvent>(onLihatKlaimmvstatuscrud);
	}

	Future<void> onTambahKlaimmvstatuscrud(
		KlaimmvstatuscrudTambahEvent event, Emitter<KlaimmvstatuscrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaimmvstatuscrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaimmvstatuscrud(
		KlaimmvstatuscrudUbahEvent event, Emitter<KlaimmvstatuscrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvstatuscrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaimmvstatuscrud(
		KlaimmvstatuscrudHapusEvent event, Emitter<KlaimmvstatuscrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvstatuscrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaimmvstatuscrud(
		KlaimmvstatuscrudLihatEvent event, Emitter<KlaimmvstatuscrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		KlaimmvstatuscrudModel? record = await repository.klaimmvstatuscrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}