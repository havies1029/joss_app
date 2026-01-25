import 'package:flutter/cupertino.dart';

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

    debugPrint('📅 PolisTanggalState.initial');
    debugPrint('mulai    : $today');
    debugPrint('berakhir : $end');

    return PolisTanggalState(
      mulai: today,
      berakhir: end,
    );
  }

  PolisTanggalState copyWith({
    DateTime? mulai,
    DateTime? berakhir,
  }) {
    debugPrint('📝 PolisTanggalState.copyWith');
    debugPrint('old mulai    : $mulai');
    debugPrint('old berakhir : $berakhir');

    final newState = PolisTanggalState(
      mulai: mulai ?? this.mulai,
      berakhir: berakhir ?? this.berakhir,
    );

    debugPrint('new mulai    : ${newState.mulai}');
    debugPrint('new berakhir : ${newState.berakhir}');

    return newState;
  }
}
