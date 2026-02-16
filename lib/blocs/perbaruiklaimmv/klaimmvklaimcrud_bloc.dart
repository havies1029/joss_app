import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvklaimcrud_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvklaimcrud_repository.dart';

part 'klaimmvklaimcrud_event.dart';
part 'klaimmvklaimcrud_state.dart';

class KlaimmvklaimcrudBloc extends Bloc<KlaimmvklaimcrudEvents, KlaimmvklaimcrudState> {
	final KlaimmvklaimcrudRepository repository;
	KlaimmvklaimcrudBloc({required this.repository}) : super(const KlaimmvklaimcrudState()) {
		on<KlaimmvklaimcrudUbahEvent>(onUbahKlaimmvklaimcrud);
		on<KlaimmvklaimcrudTambahEvent>(onTambahKlaimmvklaimcrud);
		on<KlaimmvklaimcrudHapusEvent>(onHapusKlaimmvklaimcrud);
		on<KlaimmvklaimcrudLihatEvent>(onLihatKlaimmvklaimcrud);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<FieldCurrIdChangedEvent>(onFieldCurrIdChanged);
    on<FieldDolChangedEvent>(onFieldDolChanged);
    on<FieldKlaimAmountChangedEvent>(onFieldKlaimAmountChanged);
    on<FieldKronologisChangedEvent>(onFieldKronologisChanged);
    on<KlaimmvklaimAutoSaveEvent>(onKlaimmvklaimAutoSave);
	}

	Future<void> onTambahKlaimmvklaimcrud(
		KlaimmvklaimcrudTambahEvent event, Emitter<KlaimmvklaimcrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.klaimmvklaimcrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahKlaimmvklaimcrud(
		KlaimmvklaimcrudUbahEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvklaimcrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusKlaimmvklaimcrud(
		KlaimmvklaimcrudHapusEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimmvklaimcrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatKlaimmvklaimcrud(
		KlaimmvklaimcrudLihatEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		KlaimmvklaimcrudModel? record = await repository.klaimmvklaimcrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<KlaimmvklaimcrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));
		ComboRMatauangModel comboRMatauang = event.comboRMatauang;

    KlaimmvklaimcrudModel updatedRecord = state.record!.copyWith(
      currId: comboRMatauang.rmatauangKode,
    );

		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang,
      record: updatedRecord,
      isDirty: true));
	}

  Future<void> onFieldCurrIdChanged(
      FieldCurrIdChangedEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
    if (state.record != null) {
      KlaimmvklaimcrudModel updatedRecord = state.record!.copyWith(
        currId: event.currId,
      );
      emit(state.copyWith(record: updatedRecord, isDirty: true));
    }
  }

  Future<void> onFieldDolChanged(
      FieldDolChangedEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
    if (state.record != null) {
      DateTime parsedDol = event.dol;
      KlaimmvklaimcrudModel updatedRecord = state.record!.copyWith(
        dol: parsedDol,
      );
      emit(state.copyWith(record: updatedRecord, isDirty: true));
    }
  }

  Future<void> onFieldKlaimAmountChanged(
      FieldKlaimAmountChangedEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
    if (state.record != null) {
      double parsedKlaimAmount = event.klaimAmount;
      KlaimmvklaimcrudModel updatedRecord = state.record!.copyWith(
        klaimAmount: parsedKlaimAmount,
      );
      emit(state.copyWith(record: updatedRecord, isDirty: true));
    }
  }

  Future<void> onFieldKronologisChanged(
      FieldKronologisChangedEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
    if (state.record != null) {
      KlaimmvklaimcrudModel updatedRecord = state.record!.copyWith(
        kronologis: event.kronologis,
      );
      emit(state.copyWith(record: updatedRecord, isDirty: true));
    }
  }

  Future<void> onKlaimmvklaimAutoSave(
      KlaimmvklaimAutoSaveEvent event, Emitter<KlaimmvklaimcrudState> emit) async {
    if (state.record != null && state.isDirty) {
      emit(state.copyWith(isSaving: true, isSaved: false));
      bool hasFailure = !await repository.klaimmvklaimcrudUbah(state.record!);
      emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure, isDirty: false));
    }
  }

}