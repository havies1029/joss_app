import 'package:joss_app/apis/combobox/combomwarna_api.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';

class ComboMWarnaRepository {

	Future<List<ComboMWarnaModel>> getComboMWarna(String filter) async {
		ComboMWarnaAPI api = ComboMWarnaAPI();
		return await api.getComboMWarnaAPI(filter);
	}
}
