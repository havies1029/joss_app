import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

/// 🩺 ShareHealthStateCubit
/// Mengatur state untuk data HEALTH yang dipilih untuk di-share / export.
class ShareHealthStateCubit extends Cubit<Map<String, AsetHealthCariModel>> {
  ShareHealthStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Tambah / hapus 1 item dari daftar share
  void toggleItem(AsetHealthCariModel item) {
    final updated = Map<String, AsetHealthCariModel>.from(state);

    if (updated.containsKey(item.asethealthId)) {
      updated.remove(item.asethealthId);
    } else {
      updated[item.asethealthId] = item;
    }

    emit(updated);
    _updateGlobalStatus();
  }

  /// 🔹 Pilih semua / batalkan semua
  void toggleGlobal(List<AsetHealthCariModel> items) {
    if (globalActive) {
      emit({});
    } else {
      final all = {for (var item in items) item.asethealthId: item};
      emit(all);
    }
    globalActive = !globalActive;
    _updateGlobalStatus();
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
  List<AsetHealthCariModel> get selectedItems => state.values.toList();

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
        'ID': e.asethealthId,
        'Nama': e.nama,
        'Tanggal Lahir': e.dob.toIso8601String().split('T').first,
        'Jenis Kelamin': e.jnskel,
        'Posisi': e.posisi,
        'No. Polis': e.polisNo,
        'Status': e.status,
        'Nomor Urut': e.nomor,
      };
    }).toList();
  }
}
