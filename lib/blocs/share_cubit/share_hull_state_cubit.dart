
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/gen_aset_hull/asethullcari_model.dart';

/// 🚢 ShareHullStateCubit
/// Mengatur state untuk data kapal (Hull) yang dipilih untuk di-share.
class ShareHullStateCubit extends Cubit<Map<String, AsethullCariModel>> {
  ShareHullStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Tambah / hapus 1 item dari daftar share
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

  /// 🔹 Pilih semua / batalkan semua
  void toggleGlobal(List<AsethullCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetHullId: item};
      emit(all);
    }
    globalActive = !globalActive;
  }

  /// 🔹 Update total item (buat sinkronisasi status global select all)
  void updateTotalItems(int total) {
    totalItems = total;
    _updateGlobalStatus();
  }

  /// 🔹 Cek apakah item sedang aktif (terpilih)
  bool isItemActive(String? id) {
    if (id == null) return false;
    return state.containsKey(id);
  }

  /// 🔹 Ambil semua item terpilih
  List<AsethullCariModel> get selectedItems => state.values.toList();

  /// 🔹 Siapkan data untuk export atau share
  List<Map<String, dynamic>> toExportData() {
    return state.values.map((e) => e.toJson()).toList();
  }

  /// 🔹 Reset semua pilihan
  void clear() {
    emit({});
    globalActive = false;
  }

  /// 🔹 Update status globalActive (select all / not)
  void _updateGlobalStatus() {
    globalActive = state.length == totalItems && totalItems > 0;
  }

  /// 🔹 Data siap ekspor (versi readable untuk Excel/PDF)
  List<Map<String, dynamic>> getExportData() {
    return state.values.map((e) {
      return {
        'ID': e.asetHullId,
        'Nama Kapal': e.namaKapal,
        'No. Polis': e.polisNo,
        'Currency': e.curr,
        'Premi': e.premi,
        'TSI': e.tsi,
        'Status': e.status,
      };
    }).toList();
  }
}
