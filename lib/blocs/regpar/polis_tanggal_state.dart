
class PolisTanggalState {
  final DateTime mulai;
  final DateTime berakhir;

  const PolisTanggalState({
    required this.mulai,
    required this.berakhir,
  });

  factory PolisTanggalState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(today.year + 1, today.month, today.day);

    return PolisTanggalState(
      mulai: today,
      berakhir: end,
    );
  }

  PolisTanggalState copyWith({
    DateTime? mulai,
    DateTime? berakhir,
  }) {

    final newState = PolisTanggalState(
      mulai: mulai ?? this.mulai,
      berakhir: berakhir ?? this.berakhir,
    );

    return newState;
  }
}
