import 'package:joss_app/apis/combobox/combomstsaset_api.dart';
import 'package:joss_app/models/combobox/combomstsaset_model.dart';

class ComboMStsasetRepository {

	Future<List<ComboMStsasetModel>> getComboMStsaset() async {
		ComboMStsasetAPI api = ComboMStsasetAPI();
		return await api.getComboMStsasetAPI();
	}
}
