import 'package:joss_app/apis/combobox/combomtipecst_api.dart';
import 'package:joss_app/models/combobox/combomtipecst_model.dart';

class ComboMTipeCstRepository {

	Future<List<ComboMTipeCstModel>> getComboMTipeCst() async {
		ComboMTipeCstAPI api = ComboMTipeCstAPI();
		return await api.getComboMTipeCstAPI();
	}
}
