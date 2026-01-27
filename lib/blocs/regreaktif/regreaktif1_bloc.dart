import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regreaktif/regreaktif1_model.dart';
import 'package:joss_app/repositories/regreaktif/regreaktif1_repository.dart';

part 'regreaktif1_event.dart';
part 'regreaktif1_state.dart';

class Regreaktif1Bloc extends Bloc<Regreaktif1Events, Regreaktif1State> {
	final Regreaktif1Repository repository;
	Regreaktif1Bloc({required this.repository}) : super(const Regreaktif1State()) {
		on<Regreaktif1UbahEvent>(onUbahRegreaktif1);
		on<Regreaktif1TambahEvent>(onTambahRegreaktif1);
		on<Regreaktif1HapusEvent>(onHapusRegreaktif1);
		on<Regreaktif1LihatEvent>(onLihatRegreaktif1);
	}

	Future<void> onTambahRegreaktif1(
		Regreaktif1TambahEvent event, Emitter<Regreaktif1State> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.regreaktif1Tambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRegreaktif1(
		Regreaktif1UbahEvent event, Emitter<Regreaktif1State> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regreaktif1Ubah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegreaktif1(
		Regreaktif1HapusEvent event, Emitter<Regreaktif1State> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regreaktif1Hapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegreaktif1(
		Regreaktif1LihatEvent event, Emitter<Regreaktif1State> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regreaktif1Model record = await repository.regreaktif1Lihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}