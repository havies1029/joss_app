import '../../apis/combobox/combomcobapp1_api.dart';
import '../../models/combobox/combomcobapp1_model.dart';

class ComboMCobApp1Repository {

  Future<List<ComboMCobApp1Model>> getComboMCobApp1() async {
    ComboMCobApp1API api = ComboMCobApp1API();
    return await api.getComboMCobApp1API();
  }
}
