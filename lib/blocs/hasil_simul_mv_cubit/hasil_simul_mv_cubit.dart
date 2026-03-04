import 'package:flutter_bloc/flutter_bloc.dart';
import 'hasil_simul_mv_state.dart';
import '../../../models/combobox/combommvgrupojk_model.dart';
import '../../../models/combobox/combommvjnscover_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';

class HasilSimulMvCubit extends Cubit<HasilSimulMvState> {
  HasilSimulMvCubit() : super(const HasilSimulMvState());

  void setHasil({
    required ComboMMvgrupOjkModel mvgrupOjk,
    required ComboMMvjnscoverModel mvjnscover,
    required ComboMWilayahModel wilayah,
    required int thnBuat,
    required int harga,
    required int lamaCoverBulan,
    required bool isFlood,
    required bool isEq,
    required bool isSrcc,
    required bool isTerrorism,
    required int pad,
    required int pap,
    required int pll,
    required int tpl,
    required int aw,
  }) {
    emit(state.copyWith(
      mvgrupOjk: mvgrupOjk,
      mvjnscover: mvjnscover,
      wilayah: wilayah,
      thnBuat: thnBuat,
      harga: harga,
      lamaCoverBulan: lamaCoverBulan,
      isFlood: isFlood,
      isEq: isEq,
      isSrcc: isSrcc,
      isTerrorism: isTerrorism,
      pad: pad,
      pap: pap,
      pll: pll,
      tpl: tpl,
      aw: aw,
    ));
  }
}
