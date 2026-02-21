import 'package:joss_app/apis/combobox/combomconveydetail_api.dart';
import 'package:joss_app/models/combobox/combomconveydetail_model.dart';

class ComboMConveyDetailRepository {

	Future<List<ComboMConveyDetailModel>> getComboMConveyDetail(String mopId, String conveyById) async {
		ComboMConveyDetailAPI api = ComboMConveyDetailAPI();
		return await api.getComboMConveyDetailAPI(mopId, conveyById);
	}
}
