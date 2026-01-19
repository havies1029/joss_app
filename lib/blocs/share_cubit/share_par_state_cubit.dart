import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/gen_aset_par/asetparcari_model.dart';

/// 🏢 ShareParStateCubit
/// Mengatur state data PAR (Property All Risk) yang dipilih untuk di-share.
class ShareParStateCubit extends Cubit<Map<String, AsetParCariModel>> {
  ShareParStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Toggle satu item (pilih / batalkan)
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

  /// 🔹 Pilih semua / batalkan semua
  void toggleGlobal(List<AsetParCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asetParId: item};
      emit(all);
    }
    globalActive = !globalActive;
  }

  /// 🔹 Update total item (buat sinkronisasi status global)
  void updateTotalItems(int total) {
    totalItems = total;
    _updateGlobalStatus();
  }

  /// 🔹 Cek apakah item aktif (terpilih)
  bool isItemActive(String? id) {
    if (id == null) return false;
    return state.containsKey(id);
  }

  /// 🔹 Ambil semua item terpilih
  List<AsetParCariModel> get selectedItems => state.values.toList();

  /// 🔹 Siapkan data untuk export / share
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

  List<Map<String, dynamic>> getExportData() {
    return state.values.map((e) {
      return {
        'ID': e.asetParId,
        'No. Polis': e.polisNo,
        'Alamat': e.alamat,
        'Currency': e.curr,
        'Premi': e.premi,
        'Sum Insured': e.sumInsured,
        'Status': e.status,
        'Nomor Urut': e.nomor,
      };
    }).toList();
  }
}
