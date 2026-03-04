import 'package:joss_app/models/simulmv/calcpremimv_model.dart';
import 'package:joss_app/repositories/simulmv/calcpremimv_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/simulmv/simulmvcrud_model.dart';
import 'package:joss_app/repositories/simulmv/simulmvcrud_repository.dart';

part 'simulmvcrud_event.dart';
part 'simulmvcrud_state.dart';

class SimulmvCrudBloc extends Bloc<SimulmvCrudEvents, SimulmvCrudState> {
  final SimulmvCrudRepository repository;
  SimulmvCrudBloc({required this.repository})
      : super(const SimulmvCrudState()) {
    on<SimulmvCrudUbahEvent>(onUbahSimulmvCrud);
    on<SimulmvCrudTambahEvent>(onTambahSimulmvCrud);
    on<SimulmvCrudHapusEvent>(onHapusSimulmvCrud);
    on<SimulmvCrudLihatEvent>(onLihatSimulmvCrud);
    on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
    on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
    on<ComboMMvgrupOjkChangedEvent>(onComboMMvgrupOjkChanged);
    on<SimulMVCrudInitValueEvent>(onSimulMVCrudInitValue);
    on<CheckboxIsRSCCChangedEvent>(onCheckboxIsRSCCChangedEvent);
    on<CheckboxIsEQChangedEvent>(onCheckboxIsEQChangedEvent);
    on<CheckboxIsTerrorismChangedEvent>(onCheckboxIsTerrorismChangedEvent);
    on<CheckboxIsFloodChangedEvent>(onCheckboxIsFloodChangedEvent);
    on<FieldTahunChangedEvent>(onFieldTahunChangedEvent);
    on<FieldHargaChangedEvent>(onFieldHargaChangedEvent);
    on<FieldLamaCoverChangedEvent>(onFieldLamaCoverChangedEvent);
    on<HitungPremiEvent>(onHitungPremiEvent);
    on<FieldAWChangedEvent>(onFieldAWChangedEvent);
    on<FieldPADChangedEvent>(onFieldPADChangedEvent);
    on<FieldPAPChangedEvent>(onFieldPAPChangedEvent);
    on<FieldPLLChangedEvent>(onFieldPLLChangedEvent);
    on<FieldTPLChangedEvent>(onFieldTPLChangedEvent);
  }

  Future<void> onTambahSimulmvCrud(
      SimulmvCrudTambahEvent event, Emitter<SimulmvCrudState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSaving: true, isSaved: false));
    returnData = await repository.simulmvCrudTambah(event.record);
    hasFailure = !returnData.success;
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onUbahSimulmvCrud(
      SimulmvCrudUbahEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.simulmvCrudUbah(event.record);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onHapusSimulmvCrud(
      SimulmvCrudHapusEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.simulmvCrudHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatSimulmvCrud(
      SimulmvCrudLihatEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    SimulmvCrudModel record = await repository.simulmvCrudLihat(event.recordId);
    emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
  }

  Future<void> onComboMMvjnscoverChanged(ComboMMvjnscoverChangedEvent event,
      Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    ComboMMvjnscoverModel comboMMvjnscover = event.comboMMvjnscover;
    emit(state.copyWith(
        isFieldCascoChanged: true, comboMMvjnscover: comboMMvjnscover));
  }

  Future<void> onComboMWilayahChanged(
      ComboMWilayahChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    ComboMWilayahModel comboMWilayah = event.comboMWilayah;
    emit(state.copyWith(
        isFieldCascoChanged: true, comboMWilayah: comboMWilayah));
  }

  Future<void> onComboMMvgrupOjkChanged(
      ComboMMvgrupOjkChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    ComboMMvgrupOjkModel comboMMvgrupOjk = event.comboMMvgrupOjk;
    emit(state.copyWith(
        isFieldCascoChanged: true, comboMMvgrupOjk: comboMMvgrupOjk));
  }

  Future<void> onSimulMVCrudInitValue(
      SimulMVCrudInitValueEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    SimulmvCrudModel record = await repository.simulMVCrudInitValue();

    //debugPrint(jsonEncode(record));

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      comboMMvgrupOjk: record.comboMMvgrupOjk,
      comboMWilayah: record.comboMWilayah,
      comboMMvjnscover: record.comboMMvjnscover,
    ));
  }

  Future<void> onCheckboxIsRSCCChangedEvent(
      CheckboxIsRSCCChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.isSrcc = event.isChecked;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onCheckboxIsEQChangedEvent(
      CheckboxIsEQChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.isEq = event.isChecked;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onCheckboxIsFloodChangedEvent(
      CheckboxIsFloodChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.isFlood = event.isChecked;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onCheckboxIsTerrorismChangedEvent(
      CheckboxIsTerrorismChangedEvent event,
      Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.isTerrorism = event.isChecked;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onFieldTahunChangedEvent(
      FieldTahunChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.thnBuat = event.tahun;

    emit(state.copyWith(isFieldCascoChanged: true, record: record));
  }

  Future<void> onFieldHargaChangedEvent(
      FieldHargaChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.harga = event.harga;

    emit(state.copyWith(isFieldCascoChanged: true, record: record));
  }

  Future<void> onFieldLamaCoverChangedEvent(
      FieldLamaCoverChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldCascoChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.coverBulan = event.lama;

    emit(state.copyWith(isFieldCascoChanged: true, record: record));
  }

  Future<void> onHitungPremiEvent(
      HitungPremiEvent event, Emitter<SimulmvCrudState> emit) async {
    debugPrint("onHitungPremiEvent #10");

    emit(state.copyWith(isCalculating: true, isCalculated: false));

    bool isValid = true;

    SimulmvCrudModel? record = state.record;
    List<String> errors = [];

    if (record == null) {
      isValid = false;
      debugPrint("onHitungPremiEvent #20");
    } else {
      if (record.thnBuat == null)  {
        isValid = false;
        errors.add("Field 'Tahun Pembuatan' tidak boleh kosong.");
      }
      if (record.harga == null || record.harga == 0) {
        //debugPrint("record.harga : ${record.harga}");
        isValid = false;
        errors.add("Field 'Harga Kendaraan' tidak boleh kosong.");
      }
      if (record.coverBulan == null || record.coverBulan == 0) {
        isValid = false;
        errors.add("Field 'Lama Cover' tidak boleh kosong.");
      }
    }

    if (isValid) {
      CalcPremiMvRepository repo = CalcPremiMvRepository();
      CalcPremiMvModel returnData = await repo.getCalcPremiMv(record!);

      bool hasFailure = !returnData.success;

      if (hasFailure) {
        isValid = false;
        if (returnData.data.isNotEmpty) {
          errors.add(returnData.data);
        }
      } else {
        record.premiAdd = returnData.premiExtCover;
        record.premiCasco = returnData.premiCasco;
        record.premiTotal = returnData.premiTotal;
      }
    }

    emit(state.copyWith(
        isCalculating: false,
        isCalculated: true,
        hasFailure: !isValid,
        errors: errors));
  }

  Future<void> onFieldAWChangedEvent(
      FieldAWChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.aw = event.awRate;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onFieldPADChangedEvent(
      FieldPADChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.pad = event.pad;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onFieldPAPChangedEvent(
      FieldPAPChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.pap = event.pap;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onFieldPLLChangedEvent(
      FieldPLLChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.pll = event.pll;
    
    debugPrint("event.pll : ${event.pll}");

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }

  Future<void> onFieldTPLChangedEvent(
      FieldTPLChangedEvent event, Emitter<SimulmvCrudState> emit) async {
    emit(state.copyWith(isFieldOpsiChanged: false));

    SimulmvCrudModel? record = state.record ?? SimulmvCrudModel();
    record.tpl = event.tpl;

    emit(state.copyWith(isFieldOpsiChanged: true, record: record));
  }
}
