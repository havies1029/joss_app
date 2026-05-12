import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';

/// 🔹 ShareRingkasanStateCubit
/// Mengelola item-item yang dipilih untuk di-share di halaman Ringkasan Aset.
class ShareRingkasanStateCubit extends Cubit<Map<String, AsetRingkasanCariModel>> {
  ShareRingkasanStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Tambah / hapus 1 item
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

  /// 🔹 Toggle semua item (select all / deselect all)
  void toggleGlobal(List<AsetRingkasanCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetRingkasanId: item};
      emit(all);
    }
    globalActive = !globalActive;
  }

  /// 🔹 Update total item untuk sinkronisasi “Select All”
  void updateTotalItems(int total) {
    totalItems = total;
    _updateGlobalStatus();
  }

  /// 🔹 Apakah item aktif (dipilih)
  bool isItemActive(String? id) {
    if (id == null) return false;
    return state.containsKey(id);
  }

  /// 🔹 Ambil semua item terpilih
  List<AsetRingkasanCariModel> get selectedItems => state.values.toList();

  /// 🔹 Siapkan data untuk ekspor / share
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
        'ID': e.asetRingkasanId,
        'Nama Aset': e.asetNama,
        'Currency': e.curr,
        'Jumlah Polis': e.jmlPolis,
        'Nilai Aset': e.nilaiAset,
        'Nilai Premi': e.nilaiPremi,
        'No Urut': e.noUrut,
      };
    }).toList();
  }

}
