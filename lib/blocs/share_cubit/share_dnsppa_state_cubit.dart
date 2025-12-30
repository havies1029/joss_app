// import 'package:flutter_bloc/flutter_bloc.dart';rt
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../models/payment/dnsppacari_model.dart';
//
// class ShareDnsppaStateCubit extends Cubit<Map<String, DnsppaCariModel>> {
//   ShareDnsppaStateCubit() : super({});
//
//   void toggleSelect(DnsppaCariModel item) {
//     final current = Map<String, DnsppaCariModel>.from(state);
//     final id = item.sppa1Id;   // 👈 ganti ID
//
//     if (current.containsKey(id)) {
//       current.remove(id);
//     } else {
//       current[id] = item;
//     }
//
//     emit(current);
//   }
//
//   void selectAll(List<DnsppaCariModel> items) {
//     final map = {
//       for (var item in items) item.sppa1Id: item,
//     };
//
//     emit(map);
//   }
//
//   void clearAll() {
//     emit({});
//   }
//
//   // list ID SPPA untuk API
//   String get selectedSppaIds => state.keys.join(';');
//
//   // list item terpilih
//   List<DnsppaCariModel> get selectedItems => state.values.toList();
// }
//   List<String> get selectedIds => state.keys.toList();
//
//   List<Map<String, dynamic>> getExportData() {
//     return state.values.map((item) => item.toJson()).toList();
//   }
//
//   void clearSelection() {
//     emit({});
//   }
//
//   void selectAll(List<DnsppaCariModel> items) {
//     final Map<String, DnsppaCariModel> newMap = {};
//     for (var item in items) {
//       newMap[item.dn1Id] = item;
//     }
//     emit(newMap);
//   }
// }
//
