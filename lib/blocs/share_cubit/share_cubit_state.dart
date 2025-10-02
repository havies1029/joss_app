import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/gen_aset_ringkasan/asetringkasancari_model.dart';
/// Cubit nyimpen full data per item
class ShareStateCubit extends Cubit<Map<String, AsetRingkasanCariModel>> {
  bool globalActive = false; // status toolbar utama

  ShareStateCubit() : super({});

  /// Toggle global → semua item masuk / reset
  void toggleGlobal(List<AsetRingkasanCariModel> items) {
    globalActive = !globalActive;

    if (globalActive) {
      final updated = {
        for (final item in items) item.asetRingkasanId: item,
      };
      emit(updated);
    } else {
      emit({});
    }
  }

  /// Toggle satu item
  void toggleItem(AsetRingkasanCariModel item) {
    final current = Map<String, AsetRingkasanCariModel>.from(state);

    if (current.containsKey(item.asetRingkasanId)) {
      current.remove(item.asetRingkasanId);
    } else {
      current[item.asetRingkasanId] = item;
    }

    emit(current);
  }

  bool isItemActive(String id) {
    return state.containsKey(id);
  }

  List<AsetRingkasanCariModel> get selectedItems =>
      state.values.toList(growable: false);
}

extension ShareStateExt on ShareStateCubit {
  List<Map<String, dynamic>> toExportData() {
    return selectedItems.map((item) => item.toJson()).toList();
  }
}
