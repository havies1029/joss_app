import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvpoliscrud_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvpoliscrud_repository.dart';

part 'klaimmvpoliscrud_event.dart';
part 'klaimmvpoliscrud_state.dart';

class KlaimmvpoliscrudBloc extends Bloc<KlaimmvpoliscrudEvents, KlaimmvpoliscrudState> {
  final KlaimmvpoliscrudRepository repository;
  KlaimmvpoliscrudBloc({required this.repository}) : super(const KlaimmvpoliscrudState()) {
    on<KlaimmvpoliscrudUbahEvent>(onUbahKlaimmvpoliscrud);
    on<KlaimmvpoliscrudTambahEvent>(onTambahKlaimmvpoliscrud);
    on<KlaimmvpoliscrudHapusEvent>(onHapusKlaimmvpoliscrud);
    on<KlaimmvpoliscrudLihatEvent>(onLihatKlaimmvpoliscrud);
    on<ComboMInsurerChangedEvent>(onComboMInsurerChanged);
    on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
    on<FieldInsuredNamaChangedEvent>(onFieldInsuredNamaChanged);
    on<FieldLaporAsuransiChangedEvent>(onFieldLaporAsuransiChanged);
    on<FieldNoChasisChangedEvent>(onFieldNoChasisChanged);
    on<FieldNoPlatChangedEvent>(onFieldNoPlatChanged);
    on<FieldPolisNoChangedEvent>(onFieldPolisNoChanged);
    on<KlaimmvPolisAutoSaveEvent>(onKlaimmvPolisAutoSave);
    on<FieldPolisMulaiChangedEvent>(onFieldPolisMulaiChanged);
    on<FieldPolisAkhirChangedEvent>(onFieldPolisAkhirChanged);
  }

  Future<void> onTambahKlaimmvpoliscrud(
      KlaimmvpoliscrudTambahEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSaving: true, isSaved: false));
    returnData = await repository.klaimmvpoliscrudTambah(event.record);
    hasFailure = !returnData.success;
    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: hasFailure));
  }

  Future<void> onUbahKlaimmvpoliscrud(
      KlaimmvpoliscrudUbahEvent event, Emitter<KlaimmvpoliscrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.klaimmvpoliscrudUbah(event.record);
    emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onHapusKlaimmvpoliscrud(
      KlaimmvpoliscrudHapusEvent event, Emitter<KlaimmvpoliscrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.klaimmvpoliscrudHapus(event.recordId);
    emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatKlaimmvpoliscrud(
      KlaimmvpoliscrudLihatEvent event,
      Emitter<KlaimmvpoliscrudState> emit
      ) async {

    emit(state.copyWith(isLoading: true, isLoaded: false));

    KlaimmvpoliscrudModel? record =
    await repository.klaimmvpoliscrudLihat(event.recordId);

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      comboMMvjnscover: record?.comboMMvjnscover,
      comboMInsurer: record?.comboMInsurer,
      isComplete: _validate(record),
    ));
  }

  Future<void> onComboMInsurerChanged(
      ComboMInsurerChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    emit(state.copyWith(isDirty: false));
    ComboMInsurerModel comboMInsurer = event.comboMInsurer;

    KlaimmvpoliscrudModel updatedRecord = state.record!.copyWith(
      minsurerId: comboMInsurer.minsurerId,
    );

    emit(state.copyWith(
      comboMInsurer: comboMInsurer,
      record: updatedRecord,
      isDirty: true,
      isValid: _validate(updatedRecord),
    ));
  }

  Future<void> onComboMMvjnscoverChanged(
      ComboMMvjnscoverChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    emit(state.copyWith(isDirty: false));
    ComboMMvjnscoverModel comboMMvjnscover = event.comboMMvjnscover;


    KlaimmvpoliscrudModel updatedRecord = state.record!.copyWith(
      mmvjnscoverId: comboMMvjnscover.mmvjnscoverId,
    );

    emit(state.copyWith(
      comboMMvjnscover: comboMMvjnscover,
      record: updatedRecord,
      isDirty: true,
      isValid: _validate(updatedRecord),
    ));
  }

  Future<void> onFieldInsuredNamaChanged(
      FieldInsuredNamaChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    String insuredNama = event.insuredNama;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(insuredNama: insuredNama);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
      isComplete: _validate(record),
    ));
  }

  Future<void> onFieldLaporAsuransiChanged(
      FieldLaporAsuransiChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    DateTime laporAsuransi = event.laporAsuransi;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(laporAsuransi: laporAsuransi);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));
  }

  Future<void> onFieldNoChasisChanged(
      FieldNoChasisChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    String noChasis = event.noChasis;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(noChasis: noChasis);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));

  }

  Future<void> onFieldNoPlatChanged(
      FieldNoPlatChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    String noPlat = event.noPlat;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(noPlat: noPlat);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));

  }

  Future<void> onFieldPolisNoChanged(
      FieldPolisNoChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    String polisNo = event.polisNo;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(polisNo: polisNo);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));
  }

  Future<void> onKlaimmvPolisAutoSave(
      KlaimmvPolisAutoSaveEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    if (!state.isDirty) return;

    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {

      bool hasFailure = true;
      emit(state.copyWith(isSaving: true, isSaved: false));

      hasFailure = !await repository.klaimmvpoliscrudUbah(record);

      emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: hasFailure,
        isDirty: false,
      ));
    }
  }

  Future<void> onFieldPolisMulaiChanged(
      FieldPolisMulaiChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    DateTime polisMulai = event.polisMulai;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(polisMulai: polisMulai);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));
  }

  Future<void> onFieldPolisAkhirChanged(
      FieldPolisAkhirChangedEvent event, Emitter<KlaimmvpoliscrudState> emit) async {

    DateTime polisAkhir = event.polisAkhir;
    KlaimmvpoliscrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(polisAkhir: polisAkhir);
    }
    emit(state.copyWith(
      record: record,
      isDirty: true,
      isValid: _validate(record),
    ));
  }

  bool _validate(KlaimmvpoliscrudModel? record) {
    if (record == null) return false;

    return record.insuredNama.isNotEmpty &&
        record.noChasis.isNotEmpty &&
        record.noPlat.isNotEmpty &&
        record.polisNo.isNotEmpty &&
        record.minsurerId?.isNotEmpty == true &&
        record.mmvjnscoverId?.isNotEmpty == true;
  }

}