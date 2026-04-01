abstract class KlaimParTanggalEvent {}

class KlaimParDolChanged extends KlaimParTanggalEvent {
  final DateTime dol;
  KlaimParDolChanged(this.dol);
}

class KlaimParLaporJpsChanged extends KlaimParTanggalEvent {
  final DateTime laporJps;
  KlaimParLaporJpsChanged(this.laporJps);
}

class KlaimParLaporAsuransiChanged extends KlaimParTanggalEvent {
  final DateTime laporAsuransi;
  KlaimParLaporAsuransiChanged(this.laporAsuransi);
}

class KlaimParTanggalInitialized extends KlaimParTanggalEvent {
  final DateTime dol;
  final DateTime laporJps;
  final DateTime laporAsuransi;

  KlaimParTanggalInitialized({
    required this.dol,
    required this.laporJps,
    required this.laporAsuransi,
  });
}