import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'regmv1crud_bloc.dart';
import 'regmv2form_bloc.dart';
import 'regmv3form_bloc.dart';
import 'regmv6form_bloc.dart';

import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';
import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

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

  void _wireListeners() {
    _subRegmv1 = regmv1CrudBloc.stream.listen((s) {
      final id = s.record?.regmv1Id ?? "";
      final ok = s.isSaved && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step2Triggered) {
        add(const RegmvFlowEnsureRegmv2Event());
      }
    });

    _subRegmv2 = regmv2FormBloc.stream.listen((s) {
      final id = s.record?.regmv2Id ?? "";
      final ok = s.isSaved && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step3Triggered) {
        add(const RegmvFlowEnsureRegmv3Event());
      }
    });

    _subRegmv3 = regmv3FormBloc.stream.listen((s) {
      final id = s.record?.regmv3Id ?? "";
      final ok = s.isSaved && !s.hasFailure && id.isNotEmpty;
      if (!ok) return;

      if (!state.step4Triggered) {
        add(const RegmvFlowHitungPremiIfReadyEvent());
      }
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


  void _triggerHitungPremi() {

    // guard: harus sudah ready id1,id2,id3
    final form1 = regmv1CrudBloc.state.record;
    final form2 = regmv2FormBloc.state.record;
    final form3 = regmv3FormBloc.state.record;

    if (form1!.regmv1Id.isEmpty) return;
    if (form2!.regmv2Id.isEmpty) return;
    if (form3!.regmv3Id.isEmpty) return;

    regmv6FormBloc.add(
      Regmv6FormHitungPremiEvent(
        regmv1Id: form1.regmv1Id,
      ),
    );
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
