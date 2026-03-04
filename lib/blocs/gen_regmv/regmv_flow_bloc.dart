import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'regmv1crud_bloc.dart';
import 'regmv2form_bloc.dart';
import 'regmv3form_bloc.dart';
import 'regmv6form_bloc.dart';

part 'regmv_flow_event.dart';
part 'regmv_flow_state.dart';

class RegmvFlowBloc extends Bloc<RegmvFlowEvent, RegmvFlowState> {
  final Regmv1CrudBloc regmv1CrudBloc;
  final Regmv2FormBloc regmv2FormBloc;
  final Regmv3FormBloc regmv3FormBloc;
  final Regmv6FormBloc regmv6FormBloc; // hitung premi

  late final StreamSubscription _subRegmv1;
  late final StreamSubscription _subRegmv2;
  late final StreamSubscription _subRegmv3;

  RegmvFlowBloc({
    required this.regmv1CrudBloc,
    required this.regmv2FormBloc,
    required this.regmv3FormBloc,
    required this.regmv6FormBloc,
  }) : super(const RegmvFlowState()) {
    on<RegmvFlowStartEvent>(_onFlowStart);
    on<RegmvFlowEnsureRegmv2Event>(_onEnsureRegmv2);
    on<RegmvFlowEnsureRegmv3Event>(_onEnsureRegmv3);
    on<RegmvFlowHitungPremiIfReadyEvent>(_onHitungPremiIfReady);

    _wireListeners();
  }

  bool _lastRegmv1Saved = false;
  bool _lastRegmv2Saved = false;
  bool _lastRegmv3Saved = false;

  void _wireListeners() {
    _subRegmv1 = regmv1CrudBloc.stream.listen((s) {
      final rising = !_lastRegmv1Saved && s.isSaved;
      _lastRegmv1Saved = s.isSaved;

      final id = s.record?.regmv1Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step2Triggered) add(const RegmvFlowEnsureRegmv2Event());
    });

    _subRegmv2 = regmv2FormBloc.stream.listen((s) {
      final rising = !_lastRegmv2Saved && s.isSaved;
      _lastRegmv2Saved = s.isSaved;

      final id = s.record?.regmv2Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step3Triggered) add(const RegmvFlowEnsureRegmv3Event());
    });

    _subRegmv3 = regmv3FormBloc.stream.listen((s) {
      final rising = !_lastRegmv3Saved && s.isSaved;
      _lastRegmv3Saved = s.isSaved;

      final id = s.record?.regmv3Id ?? "";
      final ok = rising && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step4Triggered) add(const RegmvFlowHitungPremiIfReadyEvent());
    });
  }


  @override
  Future<void> close() {
    _subRegmv1.cancel();
    _subRegmv2.cancel();
    _subRegmv3.cancel();
    return super.close();
  }

  void _onFlowStart(
      RegmvFlowStartEvent event,
      Emitter<RegmvFlowState> emit,
      ) {
    emit(const RegmvFlowState());

    _ensureRegmv1();
  }

  void _onEnsureRegmv2(
      RegmvFlowEnsureRegmv2Event event,
      Emitter<RegmvFlowState> emit,
      ) {
    if (state.step2Triggered) return;
    emit(state.copyWith(step2Triggered: true));
    _ensureRegmv2();
  }

  void _onEnsureRegmv3(
      RegmvFlowEnsureRegmv3Event event,
      Emitter<RegmvFlowState> emit,
      ) {
    if (state.step3Triggered) return;
    emit(state.copyWith(step3Triggered: true));
    _ensureRegmv3();
  }

  void _onHitungPremiIfReady(
      RegmvFlowHitungPremiIfReadyEvent event,
      Emitter<RegmvFlowState> emit,
      ) {

    emit(state.copyWith(step4Triggered: true));
    _triggerHitungPremi();
  }

  void _ensureRegmv1() {
    final form1 = regmv1CrudBloc.state.record!;
    if (form1.regmv1Id.isEmpty) {
      regmv1CrudBloc.add(Regmv1CrudTambahEvent(record: form1));
      return;
    }

    regmv1CrudBloc.add(Regmv1CrudUbahEvent(record: form1));
  }

  void _ensureRegmv2() {
    final form1 = regmv1CrudBloc.state.record!;
    if (form1.regmv1Id.isEmpty) return;

    _syncRegmv1IdToForm2And3(form1.regmv1Id);

    final form2 = regmv2FormBloc.state.record!;
    final form2WithParent = form2.copyWith(regmv1Id: form1.regmv1Id);

    if (form2.regmv2Id.isEmpty) {
      regmv2FormBloc.add(Regmv2FormTambahEvent(record: form2WithParent));
      return;
    }
    regmv2FormBloc.add(Regmv2FormUbahEvent(record: form2WithParent));
  }

  void _ensureRegmv3() {
    final form1 = regmv1CrudBloc.state.record!;
    if (form1.regmv1Id.isEmpty) return;

    _syncRegmv1IdToForm2And3(form1.regmv1Id);

    final form3 = regmv3FormBloc.state.record!;
    final form3WithParent = form3.copyWith(regmv1Id: form1.regmv1Id);

    if (form3.regmv3Id.isEmpty) {
      regmv3FormBloc.add(Regmv3FormTambahEvent(record: form3WithParent));
      return;
    }
    regmv3FormBloc.add(Regmv3FormUbahEvent(record: form3WithParent));
  }


  int _hitungPremiCallCount = 0;

  void _triggerHitungPremi() {
    _hitungPremiCallCount++;
    final now = DateTime.now().toIso8601String();

    final s1 = regmv1CrudBloc.state;
    final s2 = regmv2FormBloc.state;
    final s3 = regmv3FormBloc.state;

    final f1 = s1.record;
    final f2 = s2.record;
    final f3 = s3.record;

    debugPrint(
        "🧮 [_triggerHitungPremi] CALLED #$_hitungPremiCallCount @ $now\n"
            "  form1: isSaving=${s1.isSaving} isSaved=${s1.isSaved} hasFailure=${s1.hasFailure} id=${f1?.regmv1Id}\n"
            "  form2: isSaving=${s2.isSaving} isSaved=${s2.isSaved} hasFailure=${s2.hasFailure} id=${f2?.regmv2Id} parent=${f2?.regmv1Id}\n"
            "  form3: isSaving=${s3.isSaving} isSaved=${s3.isSaved} hasFailure=${s3.hasFailure} id=${f3?.regmv3Id} parent=${f3?.regmv1Id}\n"
    );

    // wajib record ada
    if (f1 == null || f2 == null || f3 == null) return;

    // wajib "saved beneran"
    final ok1 = s1.isSaved && !s1.hasFailure && !(s1.isSaving ?? false) && f1.regmv1Id.isNotEmpty;
    final ok2 = s2.isSaved && !s2.hasFailure && !(s2.isSaving ?? false) && f2.regmv2Id.isNotEmpty;
    final ok3 = s3.isSaved && !s3.hasFailure && !(s3.isSaving ?? false) && f3.regmv3Id.isNotEmpty;

    if (!ok1 || !ok2 || !ok3) {
      debugPrint("🧮 [_triggerHitungPremi] SKIP: belum semua form benar-benar SAVED");
      return;
    }

    debugPrint("🧮 [_triggerHitungPremi] DISPATCH hitungpremi regmv1Id=${f1.regmv1Id}");
    regmv6FormBloc.add(Regmv6FormHitungPremiEvent(regmv1Id: f1.regmv1Id));
  }



  void _syncRegmv1IdToForm2And3(String regmv1Id) {
    final form2 = regmv2FormBloc.state.record!;
    if (form2.regmv1Id != regmv1Id) {
      regmv2FormBloc.add(
        Regmv2DraftEvent(
          record: form2.copyWith(regmv1Id: regmv1Id),
        ),
      );
    }

    final form3 = regmv3FormBloc.state.record!;
    if (form3.regmv1Id != regmv1Id) {
      regmv3FormBloc.add(
        Regmv3DraftEvent(
          record: form3.copyWith(regmv1Id: regmv1Id),
        ),
      );
    }
  }
}
