import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calpar1crud_bloc.dart';
import 'calpar2form_bloc.dart';
import 'calpar3form_bloc.dart';
import 'calpar4form_bloc.dart';

part 'calpar_flow_event.dart';
part 'calpar_flow_state.dart';

class CalparFlowBloc extends Bloc<CalparFlowEvent, CalparFlowState> {
  final Calpar1CrudBloc calpar1CrudBloc;
  final Calpar2FormBloc calpar2FormBloc;
  final Calpar3FormBloc calpar3FormBloc;
  final Calpar4FormBloc calpar4FormBloc;

  late final StreamSubscription _subCalpar1;
  late final StreamSubscription _subCalpar2;
  late final StreamSubscription _subCalpar3;

  Calpar1CrudState? _prev1;
  Calpar2FormState? _prev2;
  Calpar3FormState? _prev3;

  CalparFlowBloc({
    required this.calpar1CrudBloc,
    required this.calpar2FormBloc,
    required this.calpar3FormBloc,
    required this.calpar4FormBloc,
  }) : super(const CalparFlowState()) {
    on<CalparFlowStartEvent>(_onFlowStart);
    on<CalparFlowEnsureCalpar2Event>(_onEnsureCalpar2);
    on<CalparFlowEnsureCalpar3Event>(_onEnsureCalpar3);
    on<CalparFlowHitungPremiIfReadyEvent>(_onHitungPremiIfReady);

    _wireListeners();
  }

  void _wireListeners() {
    _subCalpar1 = calpar1CrudBloc.stream.listen((s) {
      final prev = _prev1;
      _prev1 = s;

      final id = s.record?.calpar1Id ?? "";

      final justFinished =
          (prev?.isSaving == true) &&
              (s.isSaving == false) &&
              (s.isSaved == true) &&
              (s.hasFailure == false) &&
              id.isNotEmpty;

      if (justFinished && !state.step2Triggered) {
        debugPrint(
          "[${DateTime.now().toIso8601String()}] CalparFlow ENQUEUE EnsureCalpar2 (justFinished Calpar1)",
        );
        add(const CalparFlowEnsureCalpar2Event());
      }
    });

    _subCalpar2 = calpar2FormBloc.stream.listen((s) {
      final prev = _prev2;
      _prev2 = s;

      final id = s.record?.calpar2Id ?? "";

      final justFinished =
          (prev?.isSaving == true) &&
              (s.isSaving == false) &&
              (s.isSaved == true) &&
              (s.hasFailure == false) &&
              id.isNotEmpty;

      if (justFinished && !state.step3Triggered) {
        debugPrint(
          "[${DateTime.now().toIso8601String()}] CalparFlow ENQUEUE EnsureCalpar3 (justFinished Calpar2)",
        );
        add(const CalparFlowEnsureCalpar3Event());
      }
    });

    _subCalpar3 = calpar3FormBloc.stream.listen((s) {
      final prev = _prev3;
      _prev3 = s;

      final id = s.record?.calpar3Id ?? "";

      final justFinished =
          (prev?.isSaving == true) &&
              (s.isSaving == false) &&
              (s.isSaved == true) &&
              (s.hasFailure == false) &&
              id.isNotEmpty;

      if (justFinished && !state.step4Triggered) {
        debugPrint(
          "[${DateTime.now().toIso8601String()}] CalparFlow ENQUEUE HitungPremi (justFinished Calpar3)",
        );
        add(const CalparFlowHitungPremiIfReadyEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _subCalpar1.cancel();
    _subCalpar2.cancel();
    _subCalpar3.cancel();
    return super.close();
  }

  void _onFlowStart(CalparFlowStartEvent event, Emitter<CalparFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] CalparFlow START");

    _prev1 = null;
    _prev2 = null;
    _prev3 = null;

    emit(const CalparFlowState());
    _ensureCalpar1();
  }

  void _onEnsureCalpar2(
      CalparFlowEnsureCalpar2Event event, Emitter<CalparFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] CalparFlow STEP2 EnsureCalpar2");
    emit(state.copyWith(step2Triggered: true));
    _ensureCalpar2();
  }

  void _onEnsureCalpar3(
      CalparFlowEnsureCalpar3Event event, Emitter<CalparFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] CalparFlow STEP3 EnsureCalpar3");
    emit(state.copyWith(step3Triggered: true));
    _ensureCalpar3();
  }

  void _onHitungPremiIfReady(
      CalparFlowHitungPremiIfReadyEvent event, Emitter<CalparFlowState> emit) {
    debugPrint("[${DateTime.now().toIso8601String()}] CalparFlow STEP4 HitungPremiIfReady");
    emit(state.copyWith(step4Triggered: true));
    _triggerHitungPremiIfReady();
  }

  void _ensureCalpar1() {
    final form1 = calpar1CrudBloc.state.record!;
    if (form1.calpar1Id.isEmpty) {
      calpar1CrudBloc.add(Calpar1CrudTambahEvent(record: form1));
      return;
    }
    calpar1CrudBloc.add(Calpar1CrudUbahEvent(record: form1));
  }

  void _ensureCalpar2() {
    final form1 = calpar1CrudBloc.state.record!;
    if (form1.calpar1Id.isEmpty) return;

    _syncCalpar1IdToForm2And3(form1.calpar1Id);

    final form2 = calpar2FormBloc.state.record!;
    final form2WithParent = form2.copyWith(calpar1Id: form1.calpar1Id);

    if (form2.calpar2Id.isEmpty) {
      // ✅ ini yang tadi kebalik
      calpar2FormBloc.add(Calpar2FormUbahEvent(record: form2WithParent));
      return;
    }

    calpar2FormBloc.add(Calpar2FormUbahEvent(record: form2WithParent));
  }

  void _ensureCalpar3() {
    final form1 = calpar1CrudBloc.state.record!;
    if (form1.calpar1Id.isEmpty) return;

    _syncCalpar1IdToForm2And3(form1.calpar1Id);

    final form3 = calpar3FormBloc.state.record!;
    final form3WithParent = form3.copyWith(calpar1Id: form1.calpar1Id);

    if (form3.calpar3Id.isEmpty) {
      calpar3FormBloc.add(Calpar3FormUbahEvent(record: form3WithParent));
      return;
    }
    calpar3FormBloc.add(Calpar3FormUbahEvent(record: form3WithParent));
  }

  void _triggerHitungPremiIfReady() {
    final form1 = calpar1CrudBloc.state.record!;
    final form2 = calpar2FormBloc.state.record!;
    final form3 = calpar3FormBloc.state.record!;

    if (form1.calpar1Id.isEmpty) return;
    if (form2.calpar2Id.isEmpty) return;
    if (form3.calpar3Id.isEmpty) return;

    calpar4FormBloc.add(
      Calpar4FormHitungPremiEvent(calpar1Id: form1.calpar1Id),
    );
  }

  void _syncCalpar1IdToForm2And3(String calpar1Id) {
    final form2 = calpar2FormBloc.state.record!;
    if (form2.calpar1Id != calpar1Id) {
      calpar2FormBloc.add(
        Calpar2DraftEvent(record: form2.copyWith(calpar1Id: calpar1Id)),
      );
    }

    final form3 = calpar3FormBloc.state.record!;
    if (form3.calpar1Id != calpar1Id) {
      calpar3FormBloc.add(
        Calpar3DraftEvent(record: form3.copyWith(calpar1Id: calpar1Id)),
      );
    }
  }
}
