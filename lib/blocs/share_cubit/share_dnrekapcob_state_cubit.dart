// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../models/payment/dnrekapcobcari_model.dart';
// import '../../pages/payment/mobile/rincian/rincian_flat_mapper.dart';
//
// class ShareDnrekapcobStateCubit
//     extends Cubit<Map<String, DnrekapcobCariModel>> {
//   ShareDnrekapcobStateCubit() : super({});
//
//   bool globalActive = false;
//   int totalItems = 0;
//
//   //Toggle satu DN
//   void toggleItem(DnrekapcobCariModel item) {
//     final updated = Map<String, DnrekapcobCariModel>.from(state);
//     final id = item.dnrekapcobId;
//
//     if (updated.containsKey(id)) {
//       updated.remove(id);
//     } else {
//       updated[id] = item;
//     }
//
//     emit(updated);
//     _updateGlobalStatus();
//   }
//
//   //Select all / unselect all
//   void toggleGlobal(List<DnrekapcobCariModel> items) {
//     if (globalActive) {
//       emit({});
//     } else {
//       final all = {for (var i in items) i.dnrekapcobId: i};
//       emit(all);
//     }
//     globalActive = !globalActive;
//   }
//
//   //Update total items dari list
//   void updateTotalItems(int total) {
//     totalItems = total;
//     _updateGlobalStatus();
//   }
//
//   // Cek item aktif
//   bool isItemActive(String id) => state.containsKey(id);
//
//   //List item terpilih
//   List<DnrekapcobCariModel> get selectedItems =>
//       state.values.toList();
//
//   //Digunakan buat API call
//   String get selectedCobIds => state.keys.join(';');
//
//   //Data export (INI YANG DIBUTUHKAN TEMPLATE)
//   List<Map<String, dynamic>> getExportData() {
//     return state.values.map((e) => {
//       'COB': e.cobNama,
//       'JUMLAH POLIS': e.polisAmount,
//       'CURR': e.currSimbol,
//       'TOTAL NILAI PERTANGGUNGAN': e.tsi,
//       'TOTAL PREMI': e.polisAmount,
//     }).toList();
//   }
//
//   void clear() {
//     emit({});
//     globalActive = false;
//   }
//
//   void _updateGlobalStatus() {
//     globalActive = state.length == totalItems && totalItems > 0;
//   }
// }
//
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