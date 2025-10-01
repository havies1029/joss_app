import 'package:flutter_bloc/flutter_bloc.dart';

class ShareStateCubit extends Cubit<Map<String, bool>> {
  bool globalActive = false; // status toolbar utama

  ShareStateCubit() : super({});

  /// Toggle global → semua item ikut
  void toggleGlobal(List<String> itemIds) {
    globalActive = !globalActive;
    final updated = {
      for (final id in itemIds) id: globalActive,
    };
    emit(updated);
  }

  /// Toggle satu item
  void toggleItem(String itemId) {
    final current = Map<String, bool>.from(state);
    current[itemId] = !(current[itemId] ?? false);
    emit(current);
  }

  bool isItemActive(String itemId) {
    return state[itemId] ?? false;
  }
}
