import 'package:joss_app/apis/combobox/combominsurer_api.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';

class ComboMInsurerRepository {

	Future<List<ComboMInsurerModel>> getComboMInsurer(String filter) async {
		ComboMInsurerAPI api = ComboMInsurerAPI();
		return await api.getComboMInsurerAPI(filter);
	}
}
