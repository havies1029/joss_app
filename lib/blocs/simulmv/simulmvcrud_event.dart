part of 'simulmvcrud_bloc.dart';

abstract class SimulmvCrudEvents extends Equatable {
  const SimulmvCrudEvents();

  @override
  List<Object> get props => [];
}

class SimulmvCrudTambahEvent extends SimulmvCrudEvents {
  final SimulmvCrudModel record;
  const SimulmvCrudTambahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class SimulmvCrudUbahEvent extends SimulmvCrudEvents {
  final SimulmvCrudModel record;
  const SimulmvCrudUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class SimulmvCrudHapusEvent extends SimulmvCrudEvents {
  final String recordId;
  const SimulmvCrudHapusEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class SimulmvCrudLihatEvent extends SimulmvCrudEvents {
  final String recordId;
  const SimulmvCrudLihatEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class SimulMVCrudInitValueEvent extends SimulmvCrudEvents {}

class ComboMMvjnscoverChangedEvent extends SimulmvCrudEvents {
  final ComboMMvjnscoverModel comboMMvjnscover;
  const ComboMMvjnscoverChangedEvent({required this.comboMMvjnscover});

  @override
  List<Object> get props => [comboMMvjnscover];
}

class ComboMWilayahChangedEvent extends SimulmvCrudEvents {
  final ComboMWilayahModel comboMWilayah;
  const ComboMWilayahChangedEvent({required this.comboMWilayah});

  @override
  List<Object> get props => [comboMWilayah];
}

class ComboMMvgrupOjkChangedEvent extends SimulmvCrudEvents {
  final ComboMMvgrupOjkModel comboMMvgrupOjk;
  const ComboMMvgrupOjkChangedEvent({required this.comboMMvgrupOjk});

  @override
  List<Object> get props => [comboMMvgrupOjk];
}
class CheckboxIsRSCCChangedEvent extends SimulmvCrudEvents {
  final bool isChecked;
  const CheckboxIsRSCCChangedEvent({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class CheckboxIsEQChangedEvent extends SimulmvCrudEvents {
  final bool isChecked;
  const CheckboxIsEQChangedEvent({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class CheckboxIsFloodChangedEvent extends SimulmvCrudEvents {
  final bool isChecked;
  const CheckboxIsFloodChangedEvent({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class CheckboxIsTerrorismChangedEvent extends SimulmvCrudEvents {
  final bool isChecked;
  const CheckboxIsTerrorismChangedEvent({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class FieldTahunChangedEvent extends SimulmvCrudEvents {
  final int tahun;
  const FieldTahunChangedEvent({required this.tahun});

  @override
  List<Object> get props => [tahun];
}

class FieldHargaChangedEvent extends SimulmvCrudEvents {
  final double harga;
  const FieldHargaChangedEvent({required this.harga});

  @override
  List<Object> get props => [harga];
}

class FieldLamaCoverChangedEvent extends SimulmvCrudEvents {
  final int lama;
  const FieldLamaCoverChangedEvent({required this.lama});

  @override
  List<Object> get props => [lama];
}

class HitungPremiEvent extends SimulmvCrudEvents{}


class FieldAWChangedEvent extends SimulmvCrudEvents {
  final double awRate;
  const FieldAWChangedEvent({required this.awRate});

  @override
  List<Object> get props => [awRate];
}

class FieldPADChangedEvent extends SimulmvCrudEvents {
  final double pad;
  const FieldPADChangedEvent({required this.pad});

  @override
  List<Object> get props => [pad];
}

class FieldPAPChangedEvent extends SimulmvCrudEvents {
  final double pap;
  const FieldPAPChangedEvent({required this.pap});

  @override
  List<Object> get props => [pap];
}


class FieldPLLChangedEvent extends SimulmvCrudEvents {
  final double pll;
  const FieldPLLChangedEvent({required this.pll});

  @override
  List<Object> get props => [pll];
}

class FieldTPLChangedEvent extends SimulmvCrudEvents {
  final double tpl;
  const FieldTPLChangedEvent({required this.tpl});

  @override
  List<Object> get props => [tpl];
}