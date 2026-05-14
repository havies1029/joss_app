import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

class ShareHealthStateCubit extends Cubit<Map<String, AsetHealthCariModel>> {
  ShareHealthStateCubit() : super({});

  bool globalActive = false;
  int totalItems = 0;

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

  void updateTotalItems(int total) {
    totalItems = total;
    _updateGlobalStatus();
  }

  bool isItemActive(String? id) {
    if (id == null) return false;
    return state.containsKey(id);
  }

  List<AsetHealthCariModel> get selectedItems => state.values.toList();

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
        'Status': e.status ?? '-',
      };
    }).toList();
  }
}
