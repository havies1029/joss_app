
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/gen_aset_hull/asethullcari_model.dart';

class ShareHullStateCubit extends Cubit<Map<String, AsethullCariModel>> {
  ShareHullStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);
  void toggleItem(AsethullCariModel item) {
    final updated = Map<String, AsethullCariModel>.from(state);

    if (updated.containsKey(item.asetHullId)) {
      updated.remove(item.asetHullId);
    } else {
      updated[item.asetHullId] = item;
    }

    emit(updated);
    _updateGlobalStatus();
  }

  void toggleGlobal(List<AsethullCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetHullId: item};
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

  List<AsethullCariModel> get selectedItems => state.values.toList();

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
        'Nilai Pertanggungan': '${e.curr} ${formatNum(e.tsi)}',
        'Premi': '${e.curr} ${formatNum(e.premi)}',
      };
    }).toList();
  }
}
