import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment/dnrekapcobcari_model.dart';

class ShareDnrekapcobStateCubit extends Cubit<Map<String, DnrekapcobCariModel>> {
  ShareDnrekapcobStateCubit() : super({});

  void toggleSelect(DnrekapcobCariModel item) {
    final current = Map<String, DnrekapcobCariModel>.from(state);
    final id = item.dnrekapcobId;

    if (current.containsKey(id)) {
      current.remove(id);
    } else {
      current[id] = item;
    }

    emit(current);
  }

  void selectAll(List<DnrekapcobCariModel> items) {
    final map = {for (var item in items) item.dnrekapcobId: item};
    emit(map);
  }

  void clearAll() {
    emit({});
  }

  // Get selected COB IDs for API call
  String get selectedCobIds => state.keys.join(';');

  // Get selected items list
  List<DnrekapcobCariModel> get selectedItems => state.values.toList();
}

// class ShareRincianStateCubit extends Cubit<Map<String, RincianFlatItem>> {
//   ShareRincianStateCubit() : super({});
//
//   void toggle(RincianFlatItem item) {
//     final next = Map<String, RincianFlatItem>.from(state);
//     if (next.containsKey(item.dn1Id)) {
//       next.remove(item.dn1Id);
//     } else {
//       next[item.dn1Id] = item;
//     }
//     emit(next);
//   }
//
//   void clear() => emit({});
// }
