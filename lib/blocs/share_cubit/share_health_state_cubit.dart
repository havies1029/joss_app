import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

/// Cubit untuk mengatur state pemilihan data HEALTH (share / export)
class ShareHealthStateCubit extends Cubit<Map<String, AsetHealthCariModel>> {
  ShareHealthStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

  /// 🔹 Cek apakah item sedang aktif (terpilih)
  bool isItemActive(String id) => state.containsKey(id);

  /// 🔹 Toggle satu item
  void toggleItem(AsetHealthCariModel item) {
    final current = Map<String, AsetHealthCariModel>.from(state);
    if (current.containsKey(item.asethealthId)) {
      current.remove(item.asethealthId);
    } else {
      current[item.asethealthId] = item;
    }

    emit(current);
    _updateGlobalState(current);
  }

  /// 🔹 Toggle semua item (Select All / Deselect All)
  void toggleGlobal(List<AsetHealthCariModel> items) {
    if (globalActive) {
      emit({});
      globalActive = false;
    } else {
      final all = {for (var item in items) item.asethealthId: item};
      emit(all);
      globalActive = true;
    }
  }

  /// 🔹 Update total item (buat pagination awareness)
  void updateTotalItems(int count) {
    totalItems = count;
    globalActive = (state.length == count && count > 0);
  }

  /// 🔹 Reset semua pilihan
  void reset() {
    emit({});
    globalActive = false;
    totalItems = 0;
  }

  /// 🔹 Ambil daftar item yang dipilih
  List<AsetHealthCariModel> get selectedItems => state.values.toList();

  /// 🔹 Konversi data terpilih ke Map<String, dynamic> untuk ekspor
  List<Map<String, dynamic>> toExportData() {
    return state.values.map((e) => e.toJson()).toList();
  }

  /// 🔹 Private helper buat sinkronisasi globalActive
  void _updateGlobalState(Map<String, AsetHealthCariModel> current) {
    globalActive = (current.length == totalItems && totalItems > 0);
  }
}
