import 'package:joss_app/apis/combobox/combomconveyby_api.dart';
import 'package:joss_app/models/combobox/combomconveyby_model.dart';

class ComboMConveybyRepository {

	Future<List<ComboMConveybyModel>> getComboMConveyby(String mopId) async {
		ComboMConveybyAPI api = ComboMConveybyAPI();
		return await api.getComboMConveybyAPI(mopId);
	}
}
