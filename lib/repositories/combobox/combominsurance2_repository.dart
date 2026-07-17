import 'package:joss_app/apis/combobox/combominsurance2_api.dart';
import 'package:joss_app/models/combobox/combominsurance2_model.dart';

class ComboMInsurance2Repository {
	Future<List<ComboMInsurance2Model>> getComboMInsurance2(String filter) async {
		ComboMInsurance2API api = ComboMInsurance2API();
		return await api.getComboMInsurance2API(filter);
	}
}
