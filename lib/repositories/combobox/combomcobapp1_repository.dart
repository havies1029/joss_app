import 'package:joss_app/apis/combobox/combomcobapp1_api.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';

class ComboMCobApp1Repository {

  Future<List<ComboMCobApp1Model>> getComboMCobApp1(String filter) async {
    ComboMCobApp1API api = ComboMCobApp1API();
    return await api.getComboMCobApp1API(filter);
  }
}
