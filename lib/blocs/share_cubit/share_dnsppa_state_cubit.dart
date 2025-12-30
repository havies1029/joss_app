// blocs/share_cubit/share_dnsppa_state_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment/dnsppacari_model.dart';

class ShareDnsppaStateCubit extends Cubit<Map<String, DnsppaCariModel>> {
  ShareDnsppaStateCubit() : super({});

  List<String> get selectedIds => state.keys.toList();

  List<Map<String, dynamic>> getExportData() {
    return state.values.map((item) => item.toJson()).toList();
  }

  void clearSelection() {
    emit({});
  }

  void selectAll(List<DnsppaCariModel> items) {
    final Map<String, DnsppaCariModel> newMap = {};
    for (var item in items) {
      newMap[item.dn1Id] = item;
    }
    emit(newMap);
  }
}