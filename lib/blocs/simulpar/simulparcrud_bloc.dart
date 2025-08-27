import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/simulpar/calcpremipar_model.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';
import 'package:joss_app/models/simulpar/simulparcrud_model.dart';
import 'package:joss_app/repositories/simulpar/simulparcrud_repository.dart';

part 'simulparcrud_event.dart';
part 'simulparcrud_state.dart';

class SimulparCrudBloc extends Bloc<SimulparCrudEvents, SimulparCrudState> {
  final SimulparCrudRepository repository;
  SimulparCrudBloc({required this.repository})
      : super(const SimulparCrudState()) {
    on<SimulparCrudUbahEvent>(onUbahSimulparCrud);
    on<SimulparCrudTambahEvent>(onTambahSimulparCrud);
    on<SimulparCrudHapusEvent>(onHapusSimulparCrud);
    on<SimulparCrudLihatEvent>(onLihatSimulparCrud);
    on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
    on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
    on<ComboMBiindemnityOjkChangedEvent>(onComboMBiindemnityOjkChanged);
    on<ComboMKabZonaGempaChangedEvent>(onComboMKabZonaGempaChanged);
    on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
    on<ComboMTarifojkBanjirParChangedEvent>(onComboMTarifojkBanjirParChanged);
    on<SimulPARCrudInitValueEvent>(onSimulPARCrudInitValue);
    on<GetRateBawahFlexasEvent>(onGetRateBawahFlexasEvent);
    on<GetRateBawahTsfwdEvent>(onGetRateBawahTsfwdEvent);
    on<FieldRateRsmdccChangedEvent>(onFieldRateRsmdccChangedEvent);
    on<FieldRateOthersChangedEvent>(onFieldRateOthersChangedEvent);
    on<GetRateBawahEqvetEvent>(onGetRateBawahEqvetEvent);
    on<HitungPremiPAREvent>(onHitungPremiPAREvent);
    on<FieldSiBuildingChangedEvent>(onFieldSiBuildingChangedEvent);
    on<FieldSiContentChangedEvent>(onFieldSiContentChangedEvent);
    on<FieldSiMachineryChangedEvent>(onFieldSiMachineryChangedEvent);
    on<FieldSiOthersChangedEvent>(onFieldSiOthersChangedEvent);
    on<FieldSiStockChangedEvent>(onFieldSiStockChangedEvent);
    on<FieldStockAdjustableChangedEvent>(onFieldStockAdjustableChangedEvent);
    on<FieldSiBiChangedEvent>(onFieldSiBiChangedEvent);
    on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
    on<FieldBulanChangedEvent>(onFieldBulanChangedEvent);
  }

  Future<void> onTambahSimulparCrud(
      SimulparCrudTambahEvent event, Emitter<SimulparCrudState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSaving: true, isSaved: false));
    returnData = await repository.simulparCrudTambah(event.record);
    hasFailure = !returnData.success;
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onUbahSimulparCrud(
      SimulparCrudUbahEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.simulparCrudUbah(event.record);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onHapusSimulparCrud(
      SimulparCrudHapusEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.simulparCrudHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatSimulparCrud(
      SimulparCrudLihatEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    SimulparCrudModel record =
        await repository.simulparCrudLihat(event.recordId);
    emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
  }

  Future<void> onComboROkupasiChanged(
      ComboROkupasiChangedEvent event, Emitter<SimulparCrudState> emit) async {
    ComboROkupasiModel comboROkupasi = event.comboROkupasi;

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.rokupasiId = comboROkupasi.rokupasiId;

    emit(state.copyWith(record: record, comboROkupasi: comboROkupasi));

    add(GetRateBawahFlexasEvent(
        okupasiId: state.record?.rokupasiId ?? "",
        konstruksiId: state.record?.rkonstruksiojkId ?? ""));
  }

  Future<void> onComboRKonstruksiojkChanged(
      ComboRKonstruksiojkChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    ComboRKonstruksiojkModel comboRKonstruksiojk = event.comboRKonstruksiojk;

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.rkonstruksiojkId = comboRKonstruksiojk.rkonstruksiojkId;

    emit(state.copyWith(
        comboRKonstruksiojk: comboRKonstruksiojk, record: record));

    add(GetRateBawahFlexasEvent(
        okupasiId: state.record?.rokupasiId ?? "",
        konstruksiId: state.record?.rkonstruksiojkId ?? ""));
  }

  Future<void> onComboMBiindemnityOjkChanged(
      ComboMBiindemnityOjkChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    ComboMBiindemnityOjkModel? comboMBiindemnityOjk =
        event.comboMBiindemnityOjk;
    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.mbiindemnityojkId = comboMBiindemnityOjk?.mbiindemnityojkId;
    record.biIndexRate = comboMBiindemnityOjk?.rateIndex ?? 0;

    emit(state.copyWith(
        isGroupFieldRateChanged: true,
        comboMBiindemnityOjk: comboMBiindemnityOjk,
        record: record));
  }

  Future<void> onComboMKabZonaGempaChanged(ComboMKabZonaGempaChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    //emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMKabZonaGempaModel comboMKabZonaGempa = event.comboMKabZonaGempa;
    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.kab2zonagempaId = comboMKabZonaGempa.mkabzonagempaId;
    emit(
        state.copyWith(comboMKabZonaGempa: comboMKabZonaGempa, record: record));

    add(GetRateBawahEqvetEvent(
        okupasiId: state.record?.rokupasiId ?? "",
        kabupatenId: state.record?.kab2zonagempaId ?? ""));
  }

  Future<void> onComboMWilayahChanged(
      ComboMWilayahChangedEvent event, Emitter<SimulparCrudState> emit) async {
    ComboMWilayahModel? comboMWilayah = event.comboMWilayah;

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.mwilayahId = comboMWilayah?.mwilayahId;

    emit(state.copyWith(comboMWilayah: comboMWilayah, record: record));

    add(GetRateBawahTsfwdEvent(wilayahId: state.record?.mwilayahId ?? ""));
  }

  Future<void> onComboMTarifojkBanjirParChanged(
      ComboMTarifojkBanjirParChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMTarifojkBanjirParModel comboMTarifojkBanjirPar =
        event.comboMTarifojkBanjirPar;
    emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        comboMTarifojkBanjirPar: comboMTarifojkBanjirPar));
  }

  Future<void> onSimulPARCrudInitValue(
      SimulPARCrudInitValueEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    SimulparCrudModel record = await repository.simulPARCrudInitValue();

    emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: record,
        comboROkupasi: record.comboROkupasi,
        comboMWilayah: record.comboMWilayah,
        comboRKonstruksiojk: record.comboRKonstruksiojk,
        comboRMatauang: record.comboRMatauang));
  }

  Future<void> onGetRateBawahFlexasEvent(
      GetRateBawahFlexasEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();

    if (event.okupasiId.isNotEmpty && event.konstruksiId.isNotEmpty) {
      record.ratePar = await repository.simulPARCrudGetRateFlexas(
          event.okupasiId, event.konstruksiId);
    } else {
      record.ratePar = 0;
    }

    record.rateTotal = (record.ratePar ?? 0) +
        (record.rateTsfwd ?? 0) +
        (record.rateRsmdcc ?? 0) +
        (record.rateEqvet ?? 0) +
        (record.rateOther ?? 0);

    emit(state.copyWith(isGroupFieldRateChanged: true, record: record));
  }

  Future<void> onGetRateBawahTsfwdEvent(
      GetRateBawahTsfwdEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    if (event.wilayahId.isNotEmpty) {
      record.rateTsfwd =
          await repository.simulPARCrudGetRateTsfwd(event.wilayahId);
    } else {
      record.rateTsfwd = 0;
    }
    record.rateTotal = (record.ratePar ?? 0) +
        (record.rateTsfwd ?? 0) +
        (record.rateRsmdcc ?? 0) +
        (record.rateEqvet ?? 0) +
        (record.rateOther ?? 0);

    emit(state.copyWith(isGroupFieldRateChanged: true, record: record));
  }

  Future<void> onGetRateBawahEqvetEvent(
      GetRateBawahEqvetEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    if ((event.okupasiId.isNotEmpty) || (event.kabupatenId.isNotEmpty)) {
      record.rateEqvet = await repository.simulPARCrudGetRateEqvet(
          event.kabupatenId, event.okupasiId);
    } else {
      record.rateEqvet = 0;
    }
    record.rateTotal = (record.ratePar ?? 0) +
        (record.rateTsfwd ?? 0) +
        (record.rateRsmdcc ?? 0) +
        (record.rateEqvet ?? 0) +
        (record.rateOther ?? 0);

    emit(state.copyWith(isGroupFieldRateChanged: true, record: record));
  }

  Future<void> onFieldRateRsmdccChangedEvent(FieldRateRsmdccChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.rateRsmdcc = event.rateRsmdcc;
    record.rateTotal = (record.ratePar ?? 0) +
        (record.rateTsfwd ?? 0) +
        (record.rateRsmdcc ?? 0) +
        (record.rateEqvet ?? 0) +
        (record.rateOther ?? 0);

    emit(state.copyWith(isGroupFieldRateChanged: true, record: record));
  }

  Future<void> onFieldRateOthersChangedEvent(FieldRateOthersChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldRateChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.rateOther = event.rate;
    record.rateTotal = (record.ratePar ?? 0) +
        (record.rateTsfwd ?? 0) +
        (record.rateRsmdcc ?? 0) +
        (record.rateEqvet ?? 0) +
        (record.rateOther ?? 0);

    emit(state.copyWith(isGroupFieldRateChanged: true, record: record));
  }

  Future<void> onHitungPremiPAREvent(
      HitungPremiPAREvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldPremiChanged: false, hasFailure: false));

    //debugPrint("onHitungPremiPAREvent");

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    CalcpremiparModel hasil = await repository.simulPARCalPremi(record);
    List<String> errors = [];
    if (hasil.issuccess) {
      record.premiFlexas = hasil.premiflexas;
      record.premiRsmdcc = hasil.premirsmdcc;
      record.premiTsfwd = hasil.premitsfwd;
      record.premiEqvet = hasil.premieqvet;
      record.premiOthers = hasil.premiothers;
      record.premiTotal = hasil.premitotal;
    } else {
      errors.add(hasil.errordesc);
    }

    emit(state.copyWith(
        isGroupFieldPremiChanged: hasil.issuccess,
        record: record,
        errors: errors,
        hasFailure: !hasil.issuccess));
  }

  Future<void> onFieldSiBuildingChangedEvent(FieldSiBuildingChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();

    record.siBuilding = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    //debugPrint("record.siTotal : ${record.siTotal}");

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldSiContentChangedEvent(
      FieldSiContentChangedEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));
    SimulparCrudModel record = state.record ?? SimulparCrudModel();

    record.siContent = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldSiMachineryChangedEvent(
      FieldSiMachineryChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.siMachinery = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldSiOthersChangedEvent(
      FieldSiOthersChangedEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.siOther = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldSiStockChangedEvent(
      FieldSiStockChangedEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.siStock = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldStockAdjustableChangedEvent(
      FieldStockAdjustableChangedEvent event,
      Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.stockAdjustable = event.adjustable;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onFieldSiBiChangedEvent(
      FieldSiBiChangedEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldSiChanged: false));

    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.siBi = event.si;
    record.siTotal = ((record.siBuilding ?? 0) +
            (record.siContent ?? 0) +
            (record.siMachinery ?? 0) +
            (record.siOther ?? 0) +
            ((record.siStock ?? 0) * (record.stockAdjustable ?? 0) / 100) +
            (record.siBi ?? 0)) *
        1000000;

    emit(state.copyWith(isGroupFieldSiChanged: true, record: record));
  }

  Future<void> onComboRMatauangChanged(
      ComboRMatauangChangedEvent event, Emitter<SimulparCrudState> emit) async {
    emit(state.copyWith(isGroupFieldPremiChanged: false));

    ComboRMatauangModel comboRMatauang = event.comboRMatauang;
    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.currDesc = comboRMatauang.rmatauangSimbol;

    emit(state.copyWith(
        isGroupFieldPremiChanged: true,
        comboRMatauang: comboRMatauang,
        record: record));
  }

  Future<void> onFieldBulanChangedEvent(
      FieldBulanChangedEvent event, Emitter<SimulparCrudState> emit) async {
    SimulparCrudModel record = state.record ?? SimulparCrudModel();
    record.coverBulan = event.bulan;

    emit(state.copyWith(record: record));
  }
}
