import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calmv1crud_bloc.dart';
import 'calmv2form_bloc.dart';
import 'calmv3form_bloc.dart';

import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

part 'calmv_flow_event.dart';
part 'calmv_flow_state.dart';
class CalmvFlowBloc extends Bloc<CalmvFlowEvent, CalmvFlowState> {
  final Calmv1CrudBloc calmv1CrudBloc;
  final Calmv2FormBloc calmv2FormBloc;
  final Calmv3FormBloc calmv3FormBloc;

  late final StreamSubscription _subCalmv1;
  late final StreamSubscription _subCalmv2;

  CalmvFlowBloc({
    required this.calmv1CrudBloc,
    required this.calmv2FormBloc,
    required this.calmv3FormBloc,
  }) : super(const CalmvFlowState()) {
    on<CalmvFlowStartEvent>(_onFlowStart);
    on<CalmvFlowEnsureCalmv2Event>(_onEnsureCalmv2);
    on<CalmvFlowHitungPremiIfReadyEvent>(_onHitungPremiIfReady);

    _wireListeners();
  }

  Calmv1CrudState? _prev1;
  Calmv2FormState? _prev2;


  void _wireListeners() {
    _subCalmv1 = calmv1CrudBloc.stream.listen((s) {
      final prev = _prev1;
      _prev1 = s;

      final id = s.record?.calmv1Id ?? "";

      final justFinished =
          (prev?.isSaving == true) &&
              (s.isSaving == false) &&
              (s.isSaved == true) &&
              (s.hasFailure == false) &&
              id.isNotEmpty;

      if (justFinished && !state.step2Triggered) {
        debugPrint("[${DateTime.now().toIso8601String()}] Flow ENQUEUE EnsureCalmv2 (justFinished Calmv1)");
        add(const CalmvFlowEnsureCalmv2Event());
      }
    });

    _subCalmv2 = calmv2FormBloc.stream.listen((s) {
      final prev = _prev2;
      _prev2 = s;

      final id = s.record?.calmv2Id ?? "";

      final justFinished =
          (prev?.isSaving == true) &&
              (s.isSaving == false) &&
              (s.isSaved == true) &&
              (s.hasFailure == false) &&
              id.isNotEmpty;

      if (justFinished && !state.step3Triggered) {
        debugPrint("[${DateTime.now().toIso8601String()}] Flow ENQUEUE HitungPremi (justFinished Calmv2)");
        add(const CalmvFlowHitungPremiIfReadyEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _subCalmv1.cancel();
    _subCalmv2.cancel();
    return super.close();
  }

  void _onFlowStart(CalmvFlowStartEvent event, Emitter<CalmvFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] Flow START");

    _prev1 = null;
    _prev2 = null;

    emit(const CalmvFlowState());

    _ensureCalmv1();
  }


  void _onEnsureCalmv2(CalmvFlowEnsureCalmv2Event event, Emitter<CalmvFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] Flow STEP2 EnsureCalmv2");
    emit(state.copyWith(step2Triggered: true));
    _ensureCalmv2();
  }

  void _onHitungPremiIfReady(CalmvFlowHitungPremiIfReadyEvent event, Emitter<CalmvFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] Flow STEP3 HitungPremiIfReady");
    emit(state.copyWith(step3Triggered: true));
    _triggerHitungPremiIfReady();
  }

  void _ensureCalmv1() {
    final form1 = calmv1CrudBloc.state.record!;
    if (form1.calmv1Id.isEmpty) {
      calmv1CrudBloc.add(Calmv1CrudTambahEvent(record: form1));
      return;
    }
    calmv1CrudBloc.add(Calmv1CrudUbahEvent(record: form1));
  }

  void _ensureCalmv2() {
    final form1 = calmv1CrudBloc.state.record!;
    if (form1.calmv1Id.isEmpty) return;

    _syncCalmv1IdToForm2And3(form1.calmv1Id);

    final form2 = calmv2FormBloc.state.record!;
    final form2WithParent = form2.copyWith(calmv1Id: form1.calmv1Id);

    if (form2.calmv2Id.isEmpty) {
      calmv2FormBloc.add(Calmv2FormTambahEvent(record: form2WithParent));
      return;
    }
    calmv2FormBloc.add(Calmv2FormUbahEvent(record: form2WithParent));
  }

  void _triggerHitungPremiIfReady() {
    final form1 = calmv1CrudBloc.state.record!;
    final form2 = calmv2FormBloc.state.record!;

    if (form1.calmv1Id.isEmpty) return;
    if (form2.calmv2Id.isEmpty) return;

    calmv3FormBloc.add(
      Calmv3FormHitungPremiEvent(calmv1Id: form1.calmv1Id),
    );
  }

  void _syncCalmv1IdToForm2And3(String calmv1Id) {
    final form2 = calmv2FormBloc.state.record!;
    if (form2.calmv1Id != calmv1Id) {
      calmv2FormBloc.add(
        Calmv2FormDraftEvent(
          record: form2.copyWith(calmv1Id: calmv1Id),
        ),
      );
    }
  }
}
