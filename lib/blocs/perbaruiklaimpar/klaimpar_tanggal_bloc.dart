import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'klaimpar_tanggal_event.dart';
import 'klaimpar_tanggal_state.dart';

class KlaimParTanggalBloc
    extends Bloc<KlaimParTanggalEvent, KlaimParTanggalState> {
  KlaimParTanggalBloc() : super(KlaimParTanggalState.initial()) {
    on<KlaimParTanggalInitialized>((event, emit) {
      emit(state.copyWith(
        dol: DateUtils.dateOnly(event.dol),
        laporJps: DateUtils.dateOnly(event.laporJps),
        laporAsuransi: DateUtils.dateOnly(event.laporAsuransi),
      ));
    });

    on<KlaimParDolChanged>((event, emit) {
      emit(state.copyWith(
        dol: DateUtils.dateOnly(event.dol),
      ));
    });

    on<KlaimParLaporJpsChanged>((event, emit) {
      emit(state.copyWith(
        laporJps: DateUtils.dateOnly(event.laporJps),
      ));
    });

    on<KlaimParLaporAsuransiChanged>((event, emit) {
      emit(state.copyWith(
        laporAsuransi: DateUtils.dateOnly(event.laporAsuransi),
      ));
    });
  }
}