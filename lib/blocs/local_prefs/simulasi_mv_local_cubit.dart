import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/app_prefs.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class SimulasiMvLocalState {
  final ComboMMvgrupOjkModel? mvgrupOjk;
  final ComboMMvjnscoverModel? mvjnscover;
  final ComboMWilayahModel? wilayah;

  final int? thnBuat;
  final int? harga;
  final int? lamaCoverBulan;

  final bool? isFlood, isEq, isSrcc, isTerrorism;
  final int? pad, pap, pll, tpl, aw;

  const SimulasiMvLocalState({
    this.mvgrupOjk,
    this.mvjnscover,
    this.wilayah,
    this.thnBuat,
    this.harga,
    this.lamaCoverBulan,
    this.isFlood,
    this.isEq,
    this.isSrcc,
    this.isTerrorism,
    this.pad,
    this.pap,
    this.pll,
    this.tpl,
    this.aw,
  });

  SimulasiMvLocalState copyWith({
    ComboMMvgrupOjkModel? mvgrupOjk,
    ComboMMvjnscoverModel? mvjnscover,
    ComboMWilayahModel? wilayah,
    int? thnBuat,
    int? harga,
    int? lamaCoverBulan,
    bool? isFlood,
    bool? isEq,
    bool? isSrcc,
    bool? isTerrorism,
    int? pad,
    int? pap,
    int? pll,
    int? tpl,
    int? aw,
  }) {
    return SimulasiMvLocalState(
      mvgrupOjk: mvgrupOjk ?? this.mvgrupOjk,
      mvjnscover: mvjnscover ?? this.mvjnscover,
      wilayah: wilayah ?? this.wilayah,
      thnBuat: thnBuat ?? this.thnBuat,
      harga: harga ?? this.harga,
      lamaCoverBulan: lamaCoverBulan ?? this.lamaCoverBulan,
      isFlood: isFlood ?? this.isFlood,
      isEq: isEq ?? this.isEq,
      isSrcc: isSrcc ?? this.isSrcc,
      isTerrorism: isTerrorism ?? this.isTerrorism,
      pad: pad ?? this.pad,
      pap: pap ?? this.pap,
      pll: pll ?? this.pll,
      tpl: tpl ?? this.tpl,
      aw: aw ?? this.aw,
    );
  }
}

class SimulasiMvLocalCubit extends Cubit<SimulasiMvLocalState> {
  final AppPrefs prefs;
  SimulasiMvLocalCubit(this.prefs) : super(const SimulasiMvLocalState());

  void setFromSimulasi({
    required ComboMMvgrupOjkModel mvgrupOjk,
    required ComboMMvjnscoverModel mvjnscover,
    required ComboMWilayahModel wilayah,
    required int thnBuat,
    required int harga,
    required int lamaCoverBulan,
    required bool isFlood,
    required bool isEq,
    required bool isSrcc,
    required bool isTerrorism,
    required int pad,
    required int pap,
    required int pll,
    required int tpl,
    required int aw,
  }) {
    emit(SimulasiMvLocalState(
      mvgrupOjk: mvgrupOjk,
      mvjnscover: mvjnscover,
      wilayah: wilayah,
      thnBuat: thnBuat,
      harga: harga,
      lamaCoverBulan: lamaCoverBulan,
      isFlood: isFlood,
      isEq: isEq,
      isSrcc: isSrcc,
      isTerrorism: isTerrorism,
      pad: pad,
      pap: pap,
      pll: pll,
      tpl: tpl,
      aw: aw,
    ));
  }

  void clear() => emit(const SimulasiMvLocalState());
}
