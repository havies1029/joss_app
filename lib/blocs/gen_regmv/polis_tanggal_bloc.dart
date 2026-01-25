import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/polis_tanggal_event.dart';
import 'package:joss_app/blocs/gen_regmv/polis_tanggal_state.dart';

class PolisTanggalBloc extends Bloc<PolisTanggalEvent, PolisTanggalState> {
  PolisTanggalBloc() : super(PolisTanggalState.initial()) {
    on<PolisMulaiChanged>((event, emit) {
      final start = DateTime(event.mulai.year, event.mulai.month, event.mulai.day);
      final end = DateTime(start.year + 1, start.month, start.day);
      emit(state.copyWith(mulai: start, berakhir: end));
    });
  }
}

