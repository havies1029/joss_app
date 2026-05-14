part of 'klaimparklaimcrud_bloc.dart';

abstract class KlaimparklaimcrudEvents extends Equatable {
  const KlaimparklaimcrudEvents();

  @override
  List<Object> get props => [];
}

class KlaimparklaimcrudTambahEvent extends KlaimparklaimcrudEvents {
  final KlaimparklaimcrudModel record;

  const KlaimparklaimcrudTambahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class KlaimparklaimcrudUbahEvent extends KlaimparklaimcrudEvents {
  final KlaimparklaimcrudModel record;

  const KlaimparklaimcrudUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class KlaimparklaimcrudHapusEvent extends KlaimparklaimcrudEvents {
  final String recordId;

  const KlaimparklaimcrudHapusEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class KlaimparklaimcrudLihatEvent extends KlaimparklaimcrudEvents {
  final String recordId;

  const KlaimparklaimcrudLihatEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class ComboMJenisrugiChangedEvent extends KlaimparklaimcrudEvents {
  final ComboMJenisrugiModel comboMJenisrugi;

  const ComboMJenisrugiChangedEvent({required this.comboMJenisrugi});

  @override
  List<Object> get props => [comboMJenisrugi];
}

class ComboRMatauangChangedEvent extends KlaimparklaimcrudEvents {
  final ComboRMatauangModel comboRMatauang;

  const ComboRMatauangChangedEvent({required this.comboRMatauang});

  @override
  List<Object> get props => [comboRMatauang];
}

class FieldDolChangedEvent extends KlaimparklaimcrudEvents {
  final DateTime dol;

  const FieldDolChangedEvent({required this.dol});

  @override
  List<Object> get props => [dol];
}

class FieldKeteranganChangedEvent extends KlaimparklaimcrudEvents {
  final String keterangan;

  const FieldKeteranganChangedEvent({required this.keterangan});

  @override
  List<Object> get props => [keterangan];
}

class FieldLaporAsuransiChangedEvent extends KlaimparklaimcrudEvents {
  final DateTime laporAsuransi;

  const FieldLaporAsuransiChangedEvent({required this.laporAsuransi});

  @override
  List<Object> get props => [laporAsuransi];
}

class FieldLaporJpsChangedEvent extends KlaimparklaimcrudEvents {
  final DateTime laporJps;

  const FieldLaporJpsChangedEvent({required this.laporJps});

  @override
  List<Object> get props => [laporJps];
}

class FieldPenyebabChangedEvent extends KlaimparklaimcrudEvents {
  final String penyebab;

  const FieldPenyebabChangedEvent({required this.penyebab});

  @override
  List<Object> get props => [penyebab];
}

class FieldPicEmailChangedEvent extends KlaimparklaimcrudEvents {
  final String picEmail;

  const FieldPicEmailChangedEvent({required this.picEmail});

  @override
  List<Object> get props => [picEmail];
}

class FieldPicJabatanChangedEvent extends KlaimparklaimcrudEvents {
  final String picJabatan;

  const FieldPicJabatanChangedEvent({required this.picJabatan});

  @override
  List<Object> get props => [picJabatan];
}

class FieldPicNamaChangedEvent extends KlaimparklaimcrudEvents {
  final String picNama;

  const FieldPicNamaChangedEvent({required this.picNama});

  @override
  List<Object> get props => [picNama];
}

class FieldPicTelpChangedEvent extends KlaimparklaimcrudEvents {
  final String picTelp;

  const FieldPicTelpChangedEvent({required this.picTelp});

  @override
  List<Object> get props => [picTelp];
}

class FieldKlaimAmountChangedEvent extends KlaimparklaimcrudEvents {
  final double klaimAmount;

  const FieldKlaimAmountChangedEvent({required this.klaimAmount});

  @override
  List<Object> get props => [klaimAmount];
}

class FieldCurrIdChangedEvent extends KlaimparklaimcrudEvents {
  final String currId;

  const FieldCurrIdChangedEvent({required this.currId});

  @override
  List<Object> get props => [currId];
}

class KlaimparklaimcrudAutoSaveEvent extends KlaimparklaimcrudEvents {}