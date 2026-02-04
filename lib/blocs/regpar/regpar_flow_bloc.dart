import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar4form_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar5form_bloc.dart';

import 'regpar1crud_bloc.dart';
import 'regpar2form_bloc.dart';
import 'regpar3form_bloc.dart';

import 'package:joss_app/models/regpar/regpar1crud_model.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';
import 'package:joss_app/models/regpar/regpar3form_model.dart';
import 'package:joss_app/models/regpar/regpar6form_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

part 'regpar_flow_event.dart';
part 'regpar_flow_state.dart';

class RegparFlowBloc extends Bloc<RegparFlowEvent, RegparFlowState> {
  final Regpar1CrudBloc regpar1CrudBloc;
  final Regpar2FormBloc regpar2FormBloc;
  final Regpar3FormBloc regpar3FormBloc;
  final Regpar4FormBloc regpar4FormBloc;
  final Regpar5FormBloc regpar5FormBloc; // hitung premi

  late final StreamSubscription _subRegpar1;
  late final StreamSubscription _subRegpar2;
  late final StreamSubscription _subRegpar3;
  late final StreamSubscription _subRegpar4;

  RegparFlowBloc({
    required this.regpar1CrudBloc,
    required this.regpar2FormBloc,
    required this.regpar3FormBloc,
    required this.regpar4FormBloc,
    required this.regpar5FormBloc,
  }) : super(const RegparFlowState()) {
    on<RegparFlowStartEvent>(_onFlowStart);
    on<RegparFlowEnsureRegpar2Event>(_onEnsureRegpar2);
    on<RegparFlowEnsureRegpar3Event>(_onEnsureRegpar3);
    on<RegparFlowEnsureRegpar4Event>(_onEnsureRegpar4);
    on<RegparFlowHitungPremiIfReadyEvent>(_onHitungPremiIfReady);

    _wireListeners();
  }

  bool _lastRegpar1Saved = false;
  bool _lastRegpar2Saved = false;
  bool _lastRegpar3Saved = false;
  bool _lastRegpar4Saved = false;

  void _wireListeners() {
    _subRegpar1 = regpar1CrudBloc.stream.listen((s) {
      final rising = !_lastRegpar1Saved && s.isSaved;
      _lastRegpar1Saved = s.isSaved;

      final id = s.record?.regpar1Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step2Triggered) add(const RegparFlowEnsureRegpar2Event());
    });

    _subRegpar2 = regpar2FormBloc.stream.listen((s) {
      final rising = !_lastRegpar2Saved && s.isSaved;
      _lastRegpar2Saved = s.isSaved;

      final id = s.record?.regpar2Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step3Triggered) add(const RegparFlowEnsureRegpar3Event());
    });

    _subRegpar3 = regpar3FormBloc.stream.listen((s) {
      final rising = !_lastRegpar3Saved && s.isSaved;
      _lastRegpar3Saved = s.isSaved;

      final id = s.record?.regpar3Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step4Triggered) add(const RegparFlowEnsureRegpar4Event());
    });

    _subRegpar4 = regpar4FormBloc.stream.listen((s) {
      final rising = !_lastRegpar4Saved && s.isSaved;
      _lastRegpar4Saved = s.isSaved;

      final id = s.record?.regpar1Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step5Triggered) add(const RegparFlowHitungPremiIfReadyEvent());
    });
  }


  @override
  Future<void> close() {
    _subRegpar1.cancel();
    _subRegpar2.cancel();
    _subRegpar3.cancel();
    _subRegpar4.cancel();
    return super.close();
  }

  void _onFlowStart(
      RegparFlowStartEvent event,
      Emitter<RegparFlowState> emit,
      ) {
    emit(const RegparFlowState());

    _ensureRegpar1();
  }

  void _onEnsureRegpar2(
      RegparFlowEnsureRegpar2Event event,
      Emitter<RegparFlowState> emit,
      ) {
    if (state.step2Triggered) return;
    emit(state.copyWith(step2Triggered: true));
    _ensureRegpar2();
  }

  void _onEnsureRegpar3(
      RegparFlowEnsureRegpar3Event event,
      Emitter<RegparFlowState> emit,
      ) {
    if (state.step3Triggered) return;
    emit(state.copyWith(step3Triggered: true));
    _ensureRegpar3();
  }

  void _onEnsureRegpar4(
      RegparFlowEnsureRegpar4Event event,
      Emitter<RegparFlowState> emit,
      ) {
    if (state.step4Triggered) return;
    emit(state.copyWith(step4Triggered: true));
    _ensureRegpar4();
  }

  void _onHitungPremiIfReady(
      RegparFlowHitungPremiIfReadyEvent event,
      Emitter<RegparFlowState> emit,
      ) {

    emit(state.copyWith(step5Triggered: true));
    _triggerHitungPremi();
  }

  void _ensureRegpar1() {
    final form1 = regpar1CrudBloc.state.record!;
    regpar1CrudBloc.add(Regpar1CrudUbahEvent(record: form1));
  }

  void _ensureRegpar2() {
    final form1 = regpar1CrudBloc.state.record!;
    if (form1.regpar1Id.isEmpty) return;

    _syncRegpar1IdToForm2And3(form1.regpar1Id);

    final form2 = regpar2FormBloc.state.record!;
    final form2WithParent = form2.copyWith(regpar1Id: form1.regpar1Id);

    regpar2FormBloc.add(Regpar2FormUbahEvent(record: form2WithParent));
  }

  void _ensureRegpar3() {
    final form1 = regpar1CrudBloc.state.record!;
    if (form1.regpar1Id.isEmpty) return;

    _syncRegpar1IdToForm2And3(form1.regpar1Id);

    final form3 = regpar3FormBloc.state.record!;
    final form3WithParent = form3.copyWith(regpar1Id: form1.regpar1Id);

    regpar3FormBloc.add(Regpar3FormUbahEvent(record: form3WithParent));
  }

  void _ensureRegpar4() {
    final form1 = regpar1CrudBloc.state.record!;
    if (form1.regpar1Id.isEmpty) return;

    _syncRegpar1IdToForm2And3(form1.regpar1Id);

    final form4 = regpar4FormBloc.state.record!;
    final form4WithParent = form4.copyWith(regpar1Id: form1.regpar1Id);

    regpar4FormBloc.add(Regpar4FormUbahEvent(record: form4WithParent));
  }


  int _hitungPremiCallCount = 0;

  void _triggerHitungPremi() {
    _hitungPremiCallCount++;

    final s1 = regpar1CrudBloc.state;
    final s2 = regpar2FormBloc.state;
    final s3 = regpar3FormBloc.state;
    final s4 = regpar4FormBloc.state;

    final f1 = s1.record;
    final f2 = s2.record;
    final f3 = s3.record;
    final f4 = s4.record;

    // wajib record ada
    if (f1 == null || f2 == null || f3 == null || f4 == null) return;

    // wajib "saved beneran"
    final ok1 = s1.isSaved && !s1.hasFailure && !(s1.isSaving ?? false) && f1.regpar1Id.isNotEmpty;
    final ok2 = s2.isSaved && !s2.hasFailure && !(s2.isSaving ?? false) && f2.regpar2Id.isNotEmpty;
    final ok3 = s3.isSaved && !s3.hasFailure && !(s3.isSaving ?? false) && f3.regpar3Id.isNotEmpty;
    final ok4 = s4.isSaved && !s4.hasFailure && !(s4.isSaving ?? false) && f4.regpar1Id.isNotEmpty;


    if (!ok1 || !ok2 || !ok3 || !ok4) {
      debugPrint("🧮 [_triggerHitungPremi] SKIP: belum semua form benar-benar SAVED");
      return;
    }

    regpar5FormBloc.add(Regpar5FormHitungPremiEvent(recordId: f1.regpar1Id));
  }



  void _syncRegpar1IdToForm2And3(String regpar1Id) {
    final form2 = regpar2FormBloc.state.record!;
    if (form2.regpar1Id != regpar1Id) {
      regpar2FormBloc.add(
        Regpar2DraftEvent(
          record: form2.copyWith(regpar1Id: regpar1Id),
        ),
      );
    }

    final form3 = regpar3FormBloc.state.record!;
    if (form3.regpar1Id != regpar1Id) {
      regpar3FormBloc.add(
        Regpar3DraftEvent(
          record: form3.copyWith(regpar1Id: regpar1Id),
        ),
      );
    }

    final form4 = regpar4FormBloc.state.record!;
    if (form4.regpar1Id != regpar1Id) {
      regpar4FormBloc.add(
        Regpar4DraftEvent(
          record: form4.copyWith(regpar1Id: regpar1Id),
        ),
      );
    }
  }
}
