import 'package:flutter_bloc/flutter_bloc.dart';
import 'hasil_simul_par_state.dart';
import '../../../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../../../models/combobox/combomwilayah_model.dart';
import '../../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../../models/combobox/comborokupasi_model.dart';

class HasilSimulParCubit extends Cubit<HasilSimulParState> {
  HasilSimulParCubit() : super(const HasilSimulParState());

  void setHasil({
    required int siBuilding,
    required int siContent,
    required int siMachinery,
    required int siStock,
    required int siOther,
    required int stockAdjustable,
    required double ratePar,
    required double rateEqvet,
    required double rateRsmdcc,
    required double rateTsfwd,
    required double rateOther,
    required double rateTotal,
    required double premiEqvet,
    required double premiRsmdcc,
    required double premiTsfwd,
    required double premiOther,
    required double premiTotal,
    required ComboMWilayahModel wilayah,
    required ComboMKabZonaGempaModel zonaGempa,
    required ComboRKonstruksiojkModel konstruksi,
    required ComboROkupasiModel okupasi,
  }) {
    emit(state.copyWith(
      siBuilding: siBuilding,
      siContent: siContent,
      siMachinery: siMachinery,
      siStock: siStock,
      siOther: siOther,
      stockAdjustable: stockAdjustable,
      ratePar: ratePar,
      rateEqvet: rateEqvet,
      rateRsmdcc: rateRsmdcc,
      rateTsfwd: rateTsfwd,
      rateOther: rateOther,
      rateTotal: rateTotal,
      premiEqvet: premiEqvet,
      premiRsmdcc: premiRsmdcc,
      premiTsfwd: premiTsfwd,
      premiOther: premiOther,
      premiTotal: premiTotal,
      wilayah: wilayah,
      zonaGempa: zonaGempa,
      konstruksi: konstruksi,
      okupasi: okupasi,
    ));
  }
}
