class KlaimParTanggalState {
  final DateTime dol;
  final DateTime laporJps;
  final DateTime laporAsuransi;

  const KlaimParTanggalState({
    required this.dol,
    required this.laporJps,
    required this.laporAsuransi,
  });

  factory KlaimParTanggalState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return KlaimParTanggalState(
      dol: today,
      laporJps: today,
      laporAsuransi: today,
    );
  }

  KlaimParTanggalState copyWith({
    DateTime? dol,
    DateTime? laporJps,
    DateTime? laporAsuransi,
  }) {
    return KlaimParTanggalState(
      dol: dol ?? this.dol,
      laporJps: laporJps ?? this.laporJps,
      laporAsuransi: laporAsuransi ?? this.laporAsuransi,
    );
  }
}