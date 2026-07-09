import 'package:joss_app/apis/combobox/combomreferral_api.dart';
import 'package:joss_app/models/combobox/combomreferral_model.dart';

class ComboMReferralRepository {
  Future<List<ComboMReferralModel>> getComboMReferral(String filter) async {
    ComboMReferralAPI api = ComboMReferralAPI();
    return await api.getComboMReferralAPI(filter);
  }
}
