import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/gen_aset_mv/asetmvcari_model.dart';

/// 🚗 ShareMvStateCubit
/// Mengatur state untuk data kendaraan (Motor Vehicle) yang dipilih untuk di-share.
class ShareMvStateCubit extends Cubit<Map<String, AsetMvCariModel>> {
  ShareMvStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Tambah / hapus 1 item dari daftar share
  void toggleItem(AsetMvCariModel item) {
    final updated = Map<String, AsetMvCariModel>.from(state);

    if (updated.containsKey(item.asetMvId)) {
      updated.remove(item.asetMvId);
    } else {
      updated[item.asetMvId] = item;
    }

    emit(updated);
    _updateGlobalStatus();
  }

  /// 🔹 Pilih semua / batalkan semua
  void toggleGlobal(List<AsetMvCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetMvId: item};
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
  List<AsetMvCariModel> get selectedItems => state.values.toList();

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
}
