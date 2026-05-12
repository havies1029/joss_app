import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';

class ShareRingkasanStateCubit extends Cubit<Map<String, AsetRingkasanCariModel>> {
  ShareRingkasanStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);
  void toggleItem(AsetRingkasanCariModel item) {
    final updated = Map<String, AsetRingkasanCariModel>.from(state);

    if (updated.containsKey(item.asetRingkasanId)) {
      updated.remove(item.asetRingkasanId);
    } else {
      updated[item.asetRingkasanId] = item;
    }

    emit(updated);
    _updateGlobalStatus();
  }

  void toggleGlobal(List<AsetRingkasanCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetRingkasanId: item};
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

  List<AsetRingkasanCariModel> get selectedItems => state.values.toList();

  List<Map<String, dynamic>> toExportData() {
    return state.values.map((e) => e.toJson()).toList();
  }

  void _updateGlobalStatus() {
    globalActive = state.length == totalItems && totalItems > 0;
  }

  void clear() {
    emit({});
    globalActive = false;
  }

  List<Map<String, dynamic>> getExportData() {
    return state.values.map((e) {
      return {
        'No': e.noUrut,
        'Jenis Polis': e.asetNama,
        'Jumlah Polis': e.jmlPolis,
        'Nilai Pertanggungan':
        '${e.curr} ${formatNum(e.nilaiAset)}',
        'Total Premi':
        '${e.curr} ${formatNum(e.nilaiPremi)}',
      };
    }).toList();
  }
}
