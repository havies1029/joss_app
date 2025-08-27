import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/profile/rekanpiccrud_model.dart';
import 'package:joss_app/repositories/profile/rekanpiccrud_repository.dart';

part 'rekanpiccrud_event.dart';
part 'rekanpiccrud_state.dart';

class RekanPicCrudBloc extends Bloc<RekanPicCrudEvents, RekanPicCrudState> {
	final RekanPicCrudRepository repository;
	RekanPicCrudBloc({required this.repository}) : super(const RekanPicCrudState()) {
		on<RekanPicCrudUbahEvent>(onUbahRekanPicCrud);
		on<RekanPicCrudTambahEvent>(onTambahRekanPicCrud);
		on<RekanPicCrudHapusEvent>(onHapusRekanPicCrud);
		on<RekanPicCrudLihatEvent>(onLihatRekanPicCrud);
	}

	Future<void> onTambahRekanPicCrud(
		RekanPicCrudTambahEvent event, Emitter<RekanPicCrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.rekanPicCrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRekanPicCrud(
		RekanPicCrudUbahEvent event, Emitter<RekanPicCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanPicCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRekanPicCrud(
		RekanPicCrudHapusEvent event, Emitter<RekanPicCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanPicCrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRekanPicCrud(
		RekanPicCrudLihatEvent event, Emitter<RekanPicCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		RekanPicCrudModel record = await repository.rekanPicCrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}