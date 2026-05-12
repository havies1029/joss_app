import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/gen_aset_par/asetparcari_model.dart';

class ShareParStateCubit extends Cubit<Map<String, AsetParCariModel>> {
  ShareParStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);
  void toggleItem(AsetParCariModel item) {
    final updated = Map<String, AsetParCariModel>.from(state);

    if (updated.containsKey(item.asetParId)) {
      updated.remove(item.asetParId);
    } else {
      updated[item.asetParId] = item;
    }

    emit(updated);
    _updateGlobalStatus();
  }

  void toggleGlobal(List<AsetParCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetParId: item};
      emit(all);
    }
    globalActive = !globalActive;
  }

  void updateTotalItems(int total) {
    totalItems = total;
    _updateGlobalStatus();
  }

  bool isItemActive(String? id) {
    if (id == null) return false;
    return state.containsKey(id);
  }

  List<AsetParCariModel> get selectedItems => state.values.toList();

  List<Map<String, dynamic>> toExportData() {
    return state.values.map((e) => e.toJson()).toList();
  }

  void clear() {
    emit({});
    globalActive = false;
  }

  void _updateGlobalStatus() {
    globalActive = state.length == totalItems && totalItems > 0;
  }

  List<Map<String, dynamic>> getExportData() {
    return state.values.map((e) {
      return {
        'No': e.nomor,
        'No Polis': e.polisNo,
        'Jumlah Objek': e.jmlObject,
        'Tertanggung': e.tertanggung,
        'Periode':
        '${DateFormat('dd MMM yyyy').format(e.periodeMulai)} - '
            '${DateFormat('dd MMM yyyy').format(e.periodeAkhir)}',
        'Nilai Pertanggungan': '${e.curr} ${formatNum(e.sumInsured)}',
        'Premi': '${e.curr} ${formatNum(e.premi)}',
      };
    }).toList();
  }
}
