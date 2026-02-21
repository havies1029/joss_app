import 'package:joss_app/apis/combobox/combomstsclaim_api.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';

class ComboMStsclaimRepository {

	Future<List<ComboMStsclaimModel>> getComboMStsclaim() async {
		ComboMStsclaimAPI api = ComboMStsclaimAPI();
		return await api.getComboMStsclaimAPI();
	}
}
