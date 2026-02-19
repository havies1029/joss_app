import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';
import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvbengkelcrud_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvbengkelcrud_repository.dart';

part 'klaimmvbengkelcrud_event.dart';
part 'klaimmvbengkelcrud_state.dart';

class KlaimmvbengkelcrudBloc extends Bloc<KlaimmvbengkelcrudEvents, KlaimmvbengkelcrudState> {
	final KlaimmvbengkelcrudRepository repository;
	KlaimmvbengkelcrudBloc({required this.repository}) : super(const KlaimmvbengkelcrudState()) {
		on<KlaimmvbengkelcrudUbahEvent>(onUbahKlaimmvbengkelcrud);
		on<KlaimmvbengkelcrudTambahEvent>(onTambahKlaimmvbengkelcrud);
		on<KlaimmvbengkelcrudHapusEvent>(onHapusKlaimmvbengkelcrud);
		on<KlaimmvbengkelcrudLihatEvent>(onLihatKlaimmvbengkelcrud);
		on<ComboMJnsbengkelChangedEvent>(onComboMJnsbengkelChanged);
		on<ComboMWilayahBengkelChangedEvent>(onComboMWilayahBengkelChanged);
		on<ComboMBengkelChangedEvent>(onComboMBengkelChanged);
    on<KlaimmvbengkelAutoSaveEvent>(onKlaimmvbengkelAutoSave);
    on<FieldNamaBengkelLainChangedEvent>(onFieldNamaBengkelLainChanged);
	}

	Future<void> onTambahKlaimmvbengkelcrud(
		KlaimmvbengkelcrudTambahEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaimmvbengkelcrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaimmvbengkelcrud(
		KlaimmvbengkelcrudUbahEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvbengkelcrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaimmvbengkelcrud(
		KlaimmvbengkelcrudHapusEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvbengkelcrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaimmvbengkelcrud(
		KlaimmvbengkelcrudLihatEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		KlaimmvbengkelcrudModel? record = await repository.klaimmvbengkelcrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMJnsbengkelChanged(
			ComboMJnsbengkelChangedEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));   

		ComboMJnsbengkelModel comboMJnsbengkel = event.comboMJnsbengkel;

    KlaimmvbengkelcrudModel updatedRecord = state.record ?? KlaimmvbengkelcrudModel.empty();

    updatedRecord = updatedRecord.copyWith(
        mjnsbengkelId: comboMJnsbengkel.mjnsbengkelId,
        mwilayahbengkelId: "",
        mbengkelId: "",
    );

		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMJnsbengkel: comboMJnsbengkel,
      comboMWilayahBengkel: null,
      comboMBengkel: null,
      record: updatedRecord,
      isDirty: true));
	}

	Future<void> onComboMWilayahBengkelChanged(
			ComboMWilayahBengkelChangedEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {

		ComboMWilayahBengkelModel comboMWilayahBengkel = event.comboMWilayahBengkel;
    KlaimmvbengkelcrudModel updatedRecord = state.record ?? KlaimmvbengkelcrudModel.empty();
    updatedRecord = updatedRecord.copyWith(
      mwilayahbengkelId: comboMWilayahBengkel.mwilayahbengkelId,
      mbengkelId: ""
    );
		emit(state.copyWith(
			comboMWilayahBengkel: comboMWilayahBengkel,
      comboMBengkel: null,
      record: updatedRecord,
      isDirty: true));
	}

	Future<void> onComboMBengkelChanged(
			ComboMBengkelChangedEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {

    emit(state.copyWith(isLoading: true, isLoaded: false));
  
		ComboMBengkelModel comboMBengkel = event.comboMBengkel;
    KlaimmvbengkelcrudModel updatedRecord = state.record ?? KlaimmvbengkelcrudModel.empty();
    updatedRecord = updatedRecord.copyWith(
      mbengkelId: comboMBengkel.mbengkelId,
    );
		emit(state.copyWith(
			comboMBengkel: comboMBengkel,
      record: updatedRecord,
      isLoading: false,
      isLoaded: true,
      isDirty: true));
	}

  Future<void> onKlaimmvbengkelAutoSave(
      KlaimmvbengkelAutoSaveEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {
    if (state.record != null && state.isDirty) {
      emit(state.copyWith(isSaving: true, isSaved: false));

      if (state.record != null){
        bool hasFailure = !await repository.klaimmvbengkelcrudUbah(state.record!);
        emit(state.copyWith(
          isSaving: false,
          isSaved: true,
          hasFailure: hasFailure,
          isDirty: false
        ));
      }
    }
  }

  Future<void> onFieldNamaBengkelLainChanged(
      FieldNamaBengkelLainChangedEvent event, Emitter<KlaimmvbengkelcrudState> emit) async {

      KlaimmvbengkelcrudModel updatedRecord = state.record ?? KlaimmvbengkelcrudModel.empty();
      updatedRecord = updatedRecord.copyWith(
        namaBengkelLain: event.namaBengkelLain,
      );
      emit(state.copyWith(record: updatedRecord, isDirty: true));
    
  }
}