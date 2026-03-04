//generate from : usp_flutter_crud_bloc

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/klaimlacak/klaimnilaicrud_model.dart';
import 'package:joss_app/repositories/klaimlacak/klaimnilaicrud_repository.dart';

part 'klaimnilaicrud_event.dart';
part 'klaimnilaicrud_state.dart';

class KlaimnilaicrudBloc extends Bloc<KlaimnilaicrudEvents, KlaimnilaicrudState> {
	final KlaimnilaicrudRepository repository;
	KlaimnilaicrudBloc({required this.repository}) : super(const KlaimnilaicrudState()) {
		on<KlaimnilaicrudUbahEvent>(onUbahKlaimnilaicrud);
		on<KlaimnilaicrudTambahEvent>(onTambahKlaimnilaicrud);
		on<KlaimnilaicrudHapusEvent>(onHapusKlaimnilaicrud);
		on<KlaimnilaicrudLihatEvent>(onLihatKlaimnilaicrud);
	}

	Future<void> onTambahKlaimnilaicrud(
		KlaimnilaicrudTambahEvent event, Emitter<KlaimnilaicrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaimnilaicrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
      klaimNilaiId: hasFailure ? "" : returnData.data,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaimnilaicrud(
		KlaimnilaicrudUbahEvent event, Emitter<KlaimnilaicrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimnilaicrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaimnilaicrud(
		KlaimnilaicrudHapusEvent event, Emitter<KlaimnilaicrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimnilaicrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaimnilaicrud(
		KlaimnilaicrudLihatEvent event, Emitter<KlaimnilaicrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		KlaimnilaicrudModel? record = await repository.klaimnilaicrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}