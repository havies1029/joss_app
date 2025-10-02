import 'package:equatable/equatable.dart';
import '../../../models/combobox/combommvgrupojk_model.dart';
import '../../../models/combobox/combommvjnscover_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';

class HasilSimulMvState extends Equatable {
  final ComboMMvgrupOjkModel mvgrupOjk;
  final ComboMMvjnscoverModel mvjnscover;
  final ComboMWilayahModel wilayah;
  final int thnBuat;
  final int harga;
  final int lamaCoverBulan;
  final bool isFlood;
  final bool isEq;
  final bool isSrcc;
  final bool isTerrorism;
  final int pad;
  final int pap;
  final int pll;
  final int tpl;
  final int aw;

  const HasilSimulMvState({
    this.mvgrupOjk = const ComboMMvgrupOjkModel(),
    this.mvjnscover = const ComboMMvjnscoverModel(),
    this.wilayah = const ComboMWilayahModel(),
    this.thnBuat = 0,
    this.harga = 0,
    this.lamaCoverBulan = 0,
    this.isFlood = false,
    this.isEq = false,
    this.isSrcc = false,
    this.isTerrorism = false,
    this.pad = 0,
    this.pap = 0,
    this.pll = 0,
    this.tpl = 0,
    this.aw = 0,
  });

  HasilSimulMvState copyWith({
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
    return HasilSimulMvState(
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

  @override
  List<Object?> get props => [
    mvgrupOjk,
    mvjnscover,
    wilayah,
    thnBuat,
    harga,
    lamaCoverBulan,
    isFlood,
    isEq,
    isSrcc,
    isTerrorism,
    pad,
    pap,
    pll,
    tpl,
    aw,
  ];
}
